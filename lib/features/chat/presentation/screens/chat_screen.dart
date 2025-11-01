import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart' as dz;
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
import 'package:tl_consultant/webrecorder/web_recorder.dart';
import 'package:tl_consultant/webrecorder/web_recorder_stub.dart'
    if (dart.library.html) 'package:tl_consultant/webrecorder/web_recorder_web.dart'
    as wr;

/// ====== AUDIO PLAYER MANAGER (audioplayers) ======

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

class AudioPlayerManager {
  final ap.AudioPlayer _player = ap.AudioPlayer();
  VoidCallback? _onComplete;

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

    _player.onDurationChanged.listen((d) => _durationCtrl.add(d));

    _player.onPositionChanged.listen((pos) async {
      final dur = await _player.getDuration() ?? Duration.zero;
      _positionCtrl.add(PositionData(pos, dur));
    });

    _player.onPlayerComplete.listen((_) {
      _playingCtrl.add(false);
      _onComplete?.call();
    });
  }

  void onComplete(VoidCallback cb) => _onComplete = cb;

  // ---- PLATFORM HELPERS -----------------------------------------------------

  bool get _isApple {
    // Platform.* throws on web, guard with kIsWeb
    if (kIsWeb) return false;
    try {
      return Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  // If the URL is Cloudinary .webm, ask Cloudinary for an mp3/aac rendition.
  String _appleSafeUrl(String url) {
    if (!_isApple) return url;
    if (!url.contains('/upload/')) return url;

    // Prefer AAC (m4a); mp3 also works.
    final isWebm = url.endsWith('.webm');
    final transformed =
        url.replaceFirst('/upload/', '/upload/f_aac/'); // or f_mp3
    return isWebm ? transformed.replaceFirst('.webm', '.m4a') : transformed;
  }

  // ---- PUBLIC API -----------------------------------------------------------

  Future<void> setSourceSmart(String pathOrUrl, {required bool isLocal}) async {
    if (isLocal) {
      await _player.setSourceDeviceFile(pathOrUrl);
    } else {
      final safeUrl = _appleSafeUrl(pathOrUrl);
      await _player.setSourceUrl(safeUrl);
    }
  }

  // (kept for compatibility)
  Future<void> setSource(String pathOrUrl, {bool isLocal = true}) =>
      setSourceSmart(pathOrUrl, isLocal: isLocal);

  Future<void> play([String? pathOrUrl, bool isLocal = true]) async {
    if (pathOrUrl != null) {
      await setSourceSmart(pathOrUrl, isLocal: isLocal);
    }
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

/// ====== PAGE ======

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = ChatController.instance;
  final uploadController = UploadController.instance;

  late final AudioPlayerManager _pmFeed;   // bubbles / feed
  late final AudioPlayerManager _pmDraft;  // input mini-player
  // Chat state
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
  // html.MediaRecorder? webRecorder;
  // html.MediaStream? webStream;
  String? webRecordingPath;

  // html.Blob? _lastWebBlob; // add to _ChatScreenState

  WebRecorder? webRecorder; // instead of html.MediaRecorder / html.Blob / urls

  // UI helpers
  bool get _showMic => _text.text.trim().isEmpty && !_isRecording;

  /// ----- Recorder init (idempotent) -----
  Future<void> _initRecorder() async {
    if (_recorderInited) return;

    if (!kIsWeb) {
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
    } else {
      //On web, no permission_handler - browser handles mic access directly
      debugPrint(
          'Web platform detected - skipping permission_handler requests');
    }
    _recorderInited = true;
  }

  /// ----- Start recording -----
  Future<void> _startRecording() async {
    if (_isRecording) return;

    if (kIsWeb) {
      try {
        webRecorder ??=
            wr.WebRecorderImpl(); // ✅ comes from the conditional import
        await webRecorder!.start();

        //        await recordWebAudio();

        // ✅ flip UI right away so you see the timer/stop/trash
        setState(() {
          _isRecording = true;
          _sec = 0;
          _draftPath = null;
        });
      } catch (e) {
        CustomSnackBar.errorSnackBar('Mic access failed: $e');
        return;
      }
    } else {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/vn_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.startRecorder(toFile: filePath, codec: fs.Codec.aacADTS);
      setState(() {
        _isRecording = true;
        _sec = 0;
        _draftPath = null;
      });
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!_isRecording) {
        t.cancel();
        return;
      }
      setState(() => _sec++);
      if (_sec >= _maxSec) {
        if (kIsWeb) {
          await stopWebAudioRecording(autoplay: true);
        } else {
          await stopLocalAudioRecording(autoplay: true);
        }
      }
    });
  }

  Future<String?> stopWebAudioRecording({bool autoplay = true}) async {
    if (!_isRecording || webRecorder == null) return _draftPath;

    final url = await webRecorder!.stop(); // blob: URL
    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _sec = 0;
      _draftPath = url; // set after it's ready
    });

    return url;
  }

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
      await _pmFeed.stop();                 // stop bubbles
      await _pmDraft.setSource(path, isLocal: true);
      await _pmDraft.play();
      chatController.activeAudioIdString.value = null;
    }
    return path;
  }

  /// ----- Discard the draft VN -----
  Future<void> _discardDraft() async {
    // Stop the draft preview player
    await _pmDraft.stop();

    if (kIsWeb) {
      // Revoke blob URL & free memory
      webRecorder?.dispose();
      webRecorder = null;
    } else if (_draftPath != null) {
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
          final map =
              (r is Map && r['data'] is Map) ? (r['data'] as Map) : (r as Map);

          final created =
              DateTime.tryParse('${map['created_at']}') ?? DateTime.now();
          final updated = DateTime.tryParse('${map['updated_at']}') ?? created;

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

  Future<void> _sendDraft() async {
    if (_draftPath == null) return;

    // 1) Ensure no other audio is playing
    await _pmDraft.stop();                          // stop input preview
    await _pmFeed.stop();                           // stop any bubble playback
    chatController.activeAudioIdString.value = null;

    // 2) Create optimistic message
    final temp = Message(
      messageId: null,
      chatId: chatController.chatId!.value,
      senderId: myId,
      senderType: consultant,
      message: _draftPath,               // local path (mobile) or blob: URL (web)
      messageType: 'audio',
      caption: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    chatController.messages.insert(0, temp);
    _scrollToEnd();

    // 3) Kick off upload
    try {
      dz.Either uploadEither;

      if (kIsWeb) {
        // Take bytes BEFORE disposing the recorder
        final bytes = await webRecorder?.takeBytes();
        if (bytes == null) {
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar('Nothing to upload. Please record again.');
          return;
        }
        final filename = 'vn_${DateTime.now().millisecondsSinceEpoch}.webm';
        uploadEither = await uploadController.mediaRepo.uploadBytesWithHttp(
          bytes,
          filename,
          "chat_audio",
          mediaType: 'audio',
          mediaSubType: 'webm',
        );
      } else {
        final f = File(_draftPath!);
        if (!await f.exists()) {
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar('Recorded file missing.');
          return;
        }
        uploadEither = await uploadController.mediaRepo.uploadFileWithHttp(
          f,
          "chat_audio",
        );
      }

      // 4) Handle upload result
      await uploadEither.fold(
            (l) async {
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar(l.message.toString());
        },
            (r) async {
          final secureUrl = r['data']?['secure_url']?.toString();
          if (secureUrl == null || secureUrl.isEmpty) {
            chatController.messages.remove(temp);
            CustomSnackBar.errorSnackBar('Upload returned an invalid URL.');
            return;
          }

          // 5) Send the uploaded URL as a message
          final either = await uploadController.chatRepo.sendChat(
            chatId: chatController.chatId!.value,
            message: secureUrl,
            messageType: strMsgType(MessageType.audio.toString()),
            parentId: null,
            caption: null,
            clientId: chatController.rxClient.value.id!,
            eventName: 'new-message',
            channel: chatController.myChannel.channelName,
          );

          either.fold(
                (l) {
              chatController.messages.remove(temp);
              CustomSnackBar.errorSnackBar(l.message.toString());
            },
                (res) {
              final map = (res is Map && res['data'] is Map)
                  ? (res['data'] as Map)
                  : (res as Map);

              final created = DateTime.tryParse('${map['created_at']}') ?? DateTime.now();
              final updated = DateTime.tryParse('${map['updated_at']}') ?? created;

              final serverMsg = Message(
                messageId: map['id'] as int?,
                chatId: map['chat_id'] as int?,
                senderId: map['sender_id'] as int?,
                parentId: map['parent_id'] as int?,
                senderType: map['sender_type'] as String?,
                message: map['message'] as String?,          // server URL
                messageType: map['message_type'] as String?, // 'audio'
                caption: map['caption'] as String?,
                read: (map['read'] as List?)?.cast<Map<String, dynamic>>(),
                createdAt: created,
                updatedAt: updated,
              );

              // Replace optimistic
              final idx = chatController.messages.indexOf(temp);
              if (idx != -1) {
                chatController.messages[idx] = serverMsg;
              } else {
                chatController.messages.insert(0, serverMsg);
              }
              chatController.messages.refresh();

              // 6) Clean local draft & recorder
              setState(() {
                _draftPath = null;
                if (kIsWeb) {
                  webRecorder?.dispose();  // revokes object URL on web
                  webRecorder = null;
                }
              });

              _scrollToEnd();
            },
          );
        },
      );
    } catch (e) {
      chatController.messages.remove(temp);
      CustomSnackBar.errorSnackBar('Upload failed: $e');
    }
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

    // instantiate the two players
    _pmFeed  = AudioPlayerManager();
    _pmDraft = AudioPlayerManager();

    _text.addListener(() => setState(() {}));
    _initRecorder();

    // initial data
    chatController.loadRecentMessages();
    chatController.initializePusher(channel: chatController.chatChannel.value);

    // load older when user scrolls to top (with reverse: true)
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final pos = _scroll.position;
      const threshold = 200.0;
      final nearTop = pos.pixels >= (pos.maxScrollExtent - threshold);
      if (nearTop && !chatController.isLoadMoreRunning.value) {
        chatController.loadOlderMessages();
      }
    });

    // When a bubble finishes, clear "active" so its slider resets
    _pmFeed.onComplete(() {
      chatController.activeAudioIdString.value = null;
    });

    // Optional: when the draft preview finishes, you may want to refresh the
    // input UI (e.g., to flip the play icon back). Not strictly required.
    _pmDraft.onComplete(() {
      setState(() {}); // safe no-op if your input depends on pmDraft streams
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _timer?.cancel();
    _text.dispose();
    _pmFeed.dispose();
    _pmDraft.dispose();
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

                          final bubbleId = (msg.messageId?.toString() ??
                              'temp-${msg.createdAt?.microsecondsSinceEpoch ?? msg.hashCode}');

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
                                      pm: _pmFeed,
                                      id: bubbleId,
                                      activeAudioId: chatController
                                          .activeAudioIdString, // RxnString
                                      // your AudioPlayerManager instance
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
                      pm: _pmDraft,
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
            onPressed: () => onStopRecording(),
          ),
        ],
      );
    }

    // 2) WEB: show the blob URL + trash
    if (kIsWeb && draftPath != null) {
      return Row(
        children: [
          const Icon(Icons.audiotrack, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              draftPath!, // blob:... url
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: onDiscardDraft,
            // 👈 clears draft → action button becomes Mic
            tooltip: 'Remove recording',
          ),
        ],
      );
    }

    // 3) NON-WEB: draft mini player
    if (draftPath != null && !kIsWeb) {
      return Row(
        children: [
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
          Expanded(
            child: StreamBuilder<PositionData>(
              stream: pm.positionDataStream,
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
                  onChanged: (v) => pm.seek(dur * v),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: onDiscardDraft,
          ),
        ],
      );
    }

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

    // WEB: if a recorded draft exists → SEND; else if typing → SEND; else MIC
    if (kIsWeb) {
      if (hasDraft) {
        return InkWell(
          onTap: onSendDraft, // 👈 uploads + sends URL
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        );
      }

      if (hasText) {
        return InkWell(
          onTap: onSendText,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        );
      }

      return InkWell(
        onTap: onStartRecording,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 48,
          height: 48,
          decoration:
              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      );
    }

    // NON-WEB: your existing behavior
    if (showMic && !hasDraft) {
      return InkWell(
        onTap: onStartRecording,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 48,
          height: 48,
          decoration:
              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
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
        decoration:
            const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}

/// ====== VOICE BUBBLE WIDGET (for sent voice notes) ======
class VoiceBubble extends StatelessWidget {
  const VoiceBubble({
    super.key,
    required this.id,
    required this.path,
    required this.fromMe,
    required this.pm,
    required this.activeAudioId,
    this.onBeforePlay, // 👈 NEW
  });

  final String id;
  final String path;
  final bool fromMe;
  final AudioPlayerManager pm;        // this is the feed/bubbles player
  final RxnString activeAudioId;
  final Future<void> Function()? onBeforePlay; // 👈 NEW

  bool get _isUrl => path.startsWith('http') || path.startsWith('blob:');

  Future<void> _activateAndPlay() async {
    // Stop draft/other player first, if provided
    if (onBeforePlay != null) await onBeforePlay!();

    activeAudioId.value = id;
    await pm.setSourceSmart(path, isLocal: !_isUrl);
    await pm.play();
  }

  @override
  Widget build(BuildContext context) {
    final color = fromMe ? Colors.white : Colors.black87;

    return Obx(() {
      final isActive = (activeAudioId.value == id);

      final playPause = isActive
          ? StreamBuilder<bool>(
        initialData: pm.isPlaying,
        stream: pm.playingStream,
        builder: (_, s) {
          final playing = s.data ?? false;
          return IconButton(
            icon: Icon(playing ? Icons.pause : Icons.play_arrow, color: color),
            onPressed: () async {
              if (playing) {
                await pm.pause();
              } else {
                if (onBeforePlay != null) await onBeforePlay!();   // 👈 ensure focus
                await pm.setSourceSmart(path, isLocal: !_isUrl);    // re-bind
                await pm.play();
              }
            },
          );
        },
      )
          : IconButton(
        icon: Icon(Icons.play_arrow, color: color),
        onPressed: _activateAndPlay,
      );

      final slider = SizedBox(
        width: 160,
        child: isActive
            ? StreamBuilder<PositionData>(
          stream: pm.positionDataStream,
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
              onChanged: (v) => pm.seek(dur * v),
              activeColor: color,
              inactiveColor: fromMe ? Colors.white70 : Colors.black26,
            );
          },
        )
            : const Slider(value: 0, min: 0, max: 1, onChanged: null),
      );

      return Row(mainAxisSize: MainAxisSize.min, children: [playPause, slider]);
    });
  }
}
