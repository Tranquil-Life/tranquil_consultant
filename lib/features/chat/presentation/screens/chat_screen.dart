import 'dart:async';
import 'dart:io';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart' as av;
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_app_bar.dart';

/// ====== AUDIO PLAYER MANAGER (audioplayers) ======

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

class AudioPlayerManager {
  final ap.AudioPlayer _player = ap.AudioPlayer();
  bool _isPlaying = false;

  final _playingCtrl = StreamController<bool>.broadcast();
  final _durationCtrl = StreamController<Duration>.broadcast();
  final _positionCtrl = StreamController<PositionData>.broadcast();

  Stream<bool> get playingStream => _playingCtrl.stream;

  Stream<Duration> get durationStream => _durationCtrl.stream;

  Stream<PositionData> get positionDataStream => _positionCtrl.stream;

  bool get isPlaying => _isPlaying;

  AudioPlayerManager() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = (state == ap.PlayerState.playing);
      _playingCtrl.add(_isPlaying);
    });

    _player.onPositionChanged.listen((pos) async {
      final dur = await _player.getDuration();
      final d = dur ?? Duration.zero;
      _durationCtrl.add(d);
      _positionCtrl.add(PositionData(pos, d));
    });
  }

  Future<void> setSource(String pathOrUrl, {bool isLocal = true}) async {
    if (isLocal) {
      await _player.setSourceDeviceFile(pathOrUrl);
    } else {
      await _player.setSourceUrl(pathOrUrl);
    }
  }

  Future<void> play([String? pathOrUrl, bool isLocal = true]) async {
    if (pathOrUrl != null) await setSource(pathOrUrl, isLocal: isLocal);
    await _player.resume();
  }

  Future<void> pause() async => _player.pause();

  Future<void> stop() async => _player.stop();

  Future<void> seek(Duration pos) async => _player.seek(pos);

  Future<void> toggle() async {
    if (_isPlaying) {
      await pause();
    } else {
      await _player.resume();
    }
  }

  void dispose() {
    _player.dispose();
    _playingCtrl.close();
    _durationCtrl.close();
    _positionCtrl.close();
  }
}

/// ====== SIMPLE CHAT MODELS ======

class ChatItem {
  final String? text;
  final String? vnPath; // local file path
  final bool fromMe;

  ChatItem.text(this.text, {this.fromMe = true}) : vnPath = null;

  ChatItem.voice(this.vnPath, {this.fromMe = true}) : text = null;

  bool get isVoice => vnPath != null;
}

/// ====== PAGE ======

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = ChatController.instance;
  final uploadController = UploadController.instance;

  // Playback (shared by draft + bubbles)
  final AudioPlayerManager _pm = AudioPlayerManager();

  // Chat state
  final List<ChatItem> _items = <ChatItem>[];
  final ScrollController _scroll = ScrollController();
  final TextEditingController _text = TextEditingController();

  // Recording
  fs.FlutterSoundRecorder _recorder = fs.FlutterSoundRecorder();
  bool _recorderInited = false;
  bool _isRecording = false;
  int _sec = 0;
  Timer? _timer;
  static const int _maxSec = 60;
  String? _draftPath; // just-recorded voice note in input
  html.MediaRecorder? webRecorder;
  html.MediaStream? webStream;
  String? webRecordingPath;

  // UI helpers
  bool get _showMic => _text.text.trim().isEmpty && !_isRecording;

  /// ----- Recorder init (idempotent) -----
  Future<void> _initRecorder() async {
    if (_recorderInited) return;

   if(!kIsWeb){
     //Only request this on mobile
     final status = await Permission.microphone.request();
     await Permission.manageExternalStorage.request();

     if (status != PermissionStatus.granted) {
       debugPrint('Microphone permission is not granted');
     }

     _recorder = fs.FlutterSoundRecorder();
     await _recorder.openRecorder();
     final session = await av.AudioSession.instance;

     await session.configure(av.AudioSessionConfiguration(
       avAudioSessionCategory: av.AVAudioSessionCategory.playAndRecord,
       avAudioSessionCategoryOptions:
       av.AVAudioSessionCategoryOptions.allowBluetooth |
       av.AVAudioSessionCategoryOptions.defaultToSpeaker,
       avAudioSessionMode: av.AVAudioSessionMode.spokenAudio,
       avAudioSessionRouteSharingPolicy:
       av.AVAudioSessionRouteSharingPolicy.defaultPolicy,
       avAudioSessionSetActiveOptions: av.AVAudioSessionSetActiveOptions.none,
       androidAudioAttributes: const av.AndroidAudioAttributes(
         contentType: av.AndroidAudioContentType.speech,
         flags: av.AndroidAudioFlags.none,
         usage: av.AndroidAudioUsage.voiceCommunication,
       ),
       androidAudioFocusGainType: av.AndroidAudioFocusGainType.gain,
       androidWillPauseWhenDucked: true,
     ));

   }else{
     //On web, no permission_handler - browser handles mic access directly
     debugPrint('Web platform detected - skipping permission_handler requests');
   }
    _recorderInited = true;
  }

  /// ----- Start recording -----
  Future<void> _startRecording() async {
    if (_isRecording) {
      return;
    } else {
      if (kIsWeb) {
        recordWebAudio();
      } else {
        final dir = await getTemporaryDirectory();
        final filePath =
            '${dir.path}/vn_${DateTime.now().millisecondsSinceEpoch}.aac';

        await _recorder.startRecorder(
          toFile: filePath,
          codec: fs.Codec.aacADTS,
        );
      }

      //change ui state
      setState(() {
        _isRecording = true;
        _sec = 0;
        _draftPath = null; // reset any previous draft
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
        if (!_isRecording) {
          t.cancel();
          return;
        }
        setState(() => _sec++);
        if (_sec >= _maxSec) {
          if (kIsWeb) {
            await stopWebAudioRecording(autoplay: false);
          } else {
            await stopLocalAudioRecording(autoplay: false);
          }
        }
      });
    }
  }

  Future<void> recordWebAudio() async {
    try {
      // 1 Ask for mic permission
      final stream = await html.window.navigator.getUserMedia(audio: true);
      webStream = stream;
      print('🎤 Microphone permission granted.');

      // 2 Create the MediaRecorder instance
      webRecorder = html.MediaRecorder(stream);
      final List<html.Blob> chunks = [];

      // 3 When data is available (browser gives recorded chunks)
      webRecorder?.addEventListener('dataavailable', (html.Event e) {
        final dataEvent = e as html.BlobEvent;
        chunks.add(dataEvent.data!);
        print('📦 Received chunk: ${dataEvent.data!.size} bytes');
      });

      // 4 Listen for "stop" event
      webRecorder?.addEventListener('stop', (html.Event e) {
        print('🛑 Recording stopped. Combining chunks...');
        final blob = html.Blob(chunks, 'audio/webm');

        // Create blob URL
        final blobUrl = html.Url.createObjectUrl(blob);
        print('✅ Recording complete! Blob URL: $blobUrl');
        webRecordingPath = blobUrl; // this becomes your playable "path"

        // Auto-play it in browser
        final audio = html.AudioElement(blobUrl)
          ..controls = true
          ..autoplay = true;
        html.document.body!.append(audio);
        print('▶️ Playback started.');

        //"_startRecording" handles the auto stopping
      });

      // 5 Start recording
      webRecorder?.start();
      print('🔴 Recording started...');
    } catch (e) {
      print('❌ Error accessing microphone: $e');
    }
  }

  ///New one
  Future<String?> stopWebAudioRecording({bool autoplay = true}) async {
    if (!_isRecording || webRecorder == null) return _draftPath;

    final c = Completer<String?>();
    void onStopped(html.Event _) {
      webRecorder?.removeEventListener('stop', onStopped);
      c.complete(webRecordingPath);
    }

    webRecorder!.addEventListener('stop', onStopped);

    webRecorder!.stop();
    webStream?.getTracks().forEach((t) => t.stop());
    webStream = null;
    _timer?.cancel();

    final url = await c.future;

    setState(() {
      _isRecording = false;
      _sec = 0;
      _draftPath = url; // set after it's ready
    });

    return url;
  }

  ///Old stop web audio recirdung code
  // Future<String?> stopWebAudioRecording({bool autoplay = true}) async {
  //   if (!_isRecording) return _draftPath;
  //
  //   webRecorder?.stop(); // triggers the onStop event you set up
  //   _timer?.cancel();
  //
  //   setState(() {
  //     _isRecording = false;
  //     _sec = 0;
  //     _draftPath = webRecordingPath; // blob URL stored earlier
  //   });
  //
  //   if (autoplay && webRecordingPath != null) {
  //     // await _pm.setSource(webRecordingPath!, isLocal: false); // 👈 use URL mode
  //     // await _pm.play();
  //   }
  //
  //   return webRecordingPath;
  // }

  /// ----- Stop recording (returns local path) -----
  Future<String?> stopLocalAudioRecording({bool autoplay = true}) async {
    if (!_isRecording) return _draftPath;

    final path = await _recorder.stopRecorder(); // may be null in some builds
    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _sec = 0;
      _draftPath = path;
    });

    // Autoplay the draft in the input
    if (autoplay && path != null) {
      await _pm.setSource(path, isLocal: true);
      await _pm.play();
    }

    return path;
  }

  /// ----- Discard the draft VN -----
  Future<void> _discardDraft() async {
    if (kIsWeb) {
      if (webRecordingPath != null) {
        html.Url.revokeObjectUrl(webRecordingPath!);
        webRecordingPath = null;
      }
    } else if (_draftPath != null) {
      await _pm.stop();

      final f = File(_draftPath!);
      if (await f.exists()) await f.delete();
    }

    setState(() {
      _draftPath = null;
      _isRecording = false;
      _sec = 0;
    });
  }

  /// ----- Send text -----
  Future<void> _sendText() async {
    final txt = _text.text.trim();
    if (txt.isEmpty) return;

    _text.clear();

    // 1️⃣ Create a temporary optimistic message
    final temp = Message(
      messageId: null,
      chatId: chatController.chatId!.value,
      senderId: myId,
      senderType: consultant,
      message: txt,
      messageType: 'text',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Insert at top (since reverse:true)
    chatController.messages.insert(0, temp);
    _scrollToEnd();

    try {
      // 2️⃣ Call the API to send the actual message
      final either = await uploadController.chatRepo.sendChat(
        chatId: chatController.chatId!.value,
        message: txt,
        messageType: strMsgType(MessageType.text.toString()),
        parentId: null,
        caption: null,
        clientId: chatController.rxClient.value.id!,
        eventName: 'new-message',
        channel: chatController.myChannel.channelName,
      );

      // 3️⃣ Handle success or failure
      either.fold(
            (l) {
          // Error → remove optimistic bubble and show error
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar(l.message.toString());
        },
            (r) {
          // Success → build final Message object
          final map = (r is Map && r['data'] is Map)
              ? (r['data'] as Map)
              : (r as Map);

          final created =
              DateTime.tryParse('${map['created_at']}') ?? DateTime.now();
          final updated =
              DateTime.tryParse('${map['updated_at']}') ?? created;

          final serverMsg = Message(
            messageId: map['id'] as int?,
            chatId: map['chat_id'] as int?,
            senderId: map['sender_id'] as int?,
            parentId: map['parent_id'] as int?,
            senderType: map['sender_type'] as String?,
            message: map['message'] as String?,
            messageType: map['message_type'] as String?,
            caption: map['caption'] as String?,
            quoteMessage: null,
            read: (map['read'] as List?)?.cast<Map<String, dynamic>>(),
            createdAt: created,
            updatedAt: updated,
          );

          // 4️⃣ Replace temp with server message
          final index = chatController.messages.indexOf(temp);
          if (index != -1) {
            chatController.messages[index] = serverMsg;
          } else {
            chatController.messages.insert(0, serverMsg);
          }

          chatController.messages.refresh();
          _scrollToEnd();
        },
      );
    } catch (e) {
      // 5️⃣ If API throws, remove the temp and show feedback
      chatController.messages.remove(temp);
      CustomSnackBar.errorSnackBar('Failed to send message: $e');
    }
  }


  /// ----- Send draft VN -----
  Future<void> _sendDraft() async {
    if (_draftPath == null) return;
    await _pm.stop();
    setState(() {
      // _items.add(ChatItem.voice(_draftPath!, fromMe: true));
      //TODO: Uncomment
      // uploadController.handleVoiceNoteUpload(file: File(_draftPath!),
      //     chatId: chatController.chatId!.value,
      //     clientID: chatController.rxClient.value.id!);
      _draftPath = null;
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        0.0, // because reverse:true
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }


  @override
  void initState() {
    super.initState();

    _text.addListener(() => setState(() {}));
    _initRecorder();

    // initial data
    chatController.loadRecentMessages();
    chatController.initializePusher(channel: chatController.chatChannel.value);

    // 👇 load older when user scrolls to top (with reverse: true)
    // Trigger load-older when user scrolls near the top (because reverse: true)
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final pos = _scroll.position;
      const threshold = 200.0; // how close to the top to trigger

      // With reverse:true, pixels grow as you scroll "up" toward older messages.
      final nearTop = pos.pixels >= (pos.maxScrollExtent - threshold);

      if (nearTop && !chatController.isLoadMoreRunning.value) {
        chatController.loadOlderMessages();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _timer?.cancel();
    _text.dispose();
    _pm.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  /// ----- UI -----

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: const Image(
                image: AssetImage('assets/images/chat_bg.png'),
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              ),
            ),

            // Foreground content
            SafeArea(
              bottom: false, // we'll handle bottom insets for the input bar
              child: Column(
                children: [
                  const TitleBar(),

                  // Messages
                  Expanded(
                    child: Obx(() {
                      // Make a safe copy and sort descending (newest first)
                      final messages = [...chatController.messages];
                      messages
                          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                      // Update the recent message event
                      if (messages.isNotEmpty) {
                        chatController.recentMsgEvent.value = messages.first;
                      }

                      final showLoader = chatController.isLoadMoreRunning.value;
                      final totalCount = messages.length + (showLoader ? 1 : 0);

                      return ListView.builder(
                        controller: _scroll,
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        // so new messages appear at the bottom
                        padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12)
                            .add(const EdgeInsets.only(bottom: 72)),
                        itemCount: totalCount,
                        itemBuilder: (context, index) {
                          // Loader at top (because reverse:true)
                          if (showLoader && index == messages.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColorPalette.green,
                                  ),
                                ),
                              ),
                            );
                          }

                          final msg = messages[index];
                          final fromMe = (msg.senderId == myId &&
                              msg.senderType == consultant);
                          final align = fromMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start;
                          final bubbleColor = fromMe
                              ? Colors.green.shade600
                              : Colors.grey.shade200;
                          final textColor =
                              fromMe ? Colors.white : Colors.black87;

                          // Determine if it’s a voice message
                          final isVoice = msg.messageType == 'voice' ||
                              msg.messageType == 'audio';

                          return Align(
                            alignment: fromMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.78,
                              ),
                              decoration: BoxDecoration(
                                color: bubbleColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: isVoice
                                  ? VoiceBubble(
                                      path: msg.message ?? '',
                                      fromMe: fromMe,
                                      pm: _pm, // your AudioPlayerManager instance
                                    )
                                  : Column(
                                      crossAxisAlignment: align,
                                      children: [
                                        Text(
                                          msg.message ?? '',
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  // Input bar

                  SafeArea(
                    top: false,
                    child: _InputBar(
                      text: _text,
                      isRecording: _isRecording,
                      sec: _sec,
                      showMic: _showMic,
                      draftPath: _draftPath,
                      pm: _pm,
                      onStartRecording: _startRecording,
                      onStopRecording: () => kIsWeb
                          ? stopWebAudioRecording(autoplay: true)
                          : stopLocalAudioRecording(autoplay: true),
                      onDiscardDraft: _discardDraft,
                      onSendText: _sendText,
                      onSendDraft: _sendDraft,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== INPUT BAR (handles recording, draft VN, text) ======

class _InputBar extends StatelessWidget {
  const _InputBar({
    super.key,
    required this.text,
    required this.isRecording,
    required this.sec,
    required this.showMic,
    required this.draftPath,
    required this.pm,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onDiscardDraft,
    required this.onSendText,
    required this.onSendDraft,
  });

  final TextEditingController text;
  final bool isRecording;
  final int sec;
  final bool showMic;
  final String? draftPath;
  final AudioPlayerManager pm;

  final Future<void> Function() onStartRecording;
  final Future<String?> Function() onStopRecording;
  final Future<void> Function() onDiscardDraft;
  final VoidCallback onSendText;
  final Future<void> Function() onSendDraft;

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildMiddle(context),
              ),
            ),
            const SizedBox(width: 8),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddle(BuildContext context) {
    // 1) While recording: show timer + trash + stop
    if (isRecording) {
      return Row(
        children: [
          const Icon(Icons.mic, color: Colors.red),
          const SizedBox(width: 8),
          Text(_fmt(sec), style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black87),
            onPressed: () async {
              await onStopRecording(); // stop first (no autoplay)
              await onDiscardDraft(); // then discard
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.black87),
            onPressed: () => onStopRecording(), // this will autoplay draft
          ),
        ],
      );
    }

    // 2) If there is a draft VN: show mini player (seekbar) + send/trash
    if (draftPath != null && !kIsWeb) {
      return Row(
        children: [
          // Play/Pause
          StreamBuilder<bool>(
            initialData: false,
            stream: pm.playingStream,
            builder: (_, snap) {
              final playing = snap.data ?? false;
              return IconButton(
                icon: Icon(playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.green),
                onPressed: pm.toggle,
              );
            },
          ),
          // Seekbar
          Expanded(
            child: StreamBuilder<PositionData>(
              stream: pm.positionDataStream,
              builder: (_, s) {
                final pos = s.data?.position ?? Duration.zero;
                final dur = s.data?.duration ?? Duration(seconds: 1);
                final value = dur.inMilliseconds == 0
                    ? 0.0
                    : pos.inMilliseconds / dur.inMilliseconds;
                return Slider(
                  min: 0,
                  max: 1,
                  value: value.clamp(0.0, 1.0),
                  onChanged: (v) => pm.seek(dur * v),
                );
              },
            ),
          ),

          ///Unnecessary send icon
          // Send + Trash
          // IconButton(
          //   icon: const Icon(Icons.send, color: Colors.green),
          //   onPressed: onSendDraft,
          // ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: onDiscardDraft,
          ),
        ],
      );
    }

    if (draftPath != null) {}

    // 4) Default: text input
    return TextField(
      controller: text,
      minLines: 1,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: 'Type a message...',
        border: InputBorder.none,
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final hasText = text.text.trim().isNotEmpty;
    final hasDraft = draftPath != null;

    // 🔧 Web behavior:
    // - If user isn't typing, show MIC (so after stop—auto or manual—it goes back to mic)
    // - If user is typing, show SEND (sends text)
    if (kIsWeb) {
      if (!hasText) {
        return InkWell(
          onTap: onStartRecording,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        );
      }
      return InkWell(
        onTap: onSendText,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.send, color: Colors.white),
        ),
      );
    }

    // ✅ Mobile/desktop (non-web): keep your existing behavior
    if (showMic && !hasDraft) {
      return InkWell(
        onTap: onStartRecording,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      );
    }

    return InkWell(
      onTap: hasDraft ? onSendDraft : onSendText,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}

/// ====== VOICE BUBBLE WIDGET (for sent voice notes) ======

class VoiceBubble extends StatefulWidget {
  const VoiceBubble({
    Key? key,
    required this.path,
    required this.fromMe,
    required this.pm,
  }) : super(key: key);

  final String path; // local file path
  final bool fromMe;
  final AudioPlayerManager pm;

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
  bool _prepared = false;

  Future<void> _prepare() async {
    if (_prepared) return;
    _prepared = true;
    await widget.pm.setSource(widget.path, isLocal: true);
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.fromMe ? Colors.white : Colors.black87;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<bool>(
          initialData: false,
          stream: widget.pm.playingStream,
          builder: (_, s) {
            final playing = s.data ?? false;
            return IconButton(
              icon:
                  Icon(playing ? Icons.pause : Icons.play_arrow, color: color),
              onPressed: widget.pm.toggle,
            );
          },
        ),
        SizedBox(
          width: 160,
          child: StreamBuilder<PositionData>(
            stream: widget.pm.positionDataStream,
            builder: (_, s) {
              final pos = s.data?.position ?? Duration.zero;
              final dur = s.data?.duration ?? const Duration(seconds: 1);
              final value = dur.inMilliseconds == 0
                  ? 0.0
                  : pos.inMilliseconds / dur.inMilliseconds;
              return Slider(
                min: 0,
                max: 1,
                value: value.clamp(0.0, 1.0),
                onChanged: (v) => widget.pm.seek(dur * v),
                activeColor: color,
                inactiveColor: widget.fromMe ? Colors.white70 : Colors.black26,
              );
            },
          ),
        ),
      ],
    );
  }
}
