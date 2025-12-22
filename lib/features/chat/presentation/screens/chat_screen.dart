import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart' as av;
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_player_manager.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/messages_list_widget.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/input_bar.dart';
import 'package:tl_consultant/webrecorder/web_recorder.dart';
import 'package:tl_consultant/webrecorder/web_recorder_stub.dart'
    if (dart.library.html) 'package:tl_consultant/webrecorder/web_recorder_web.dart'
    as wr;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = ChatController.instance;
  final uploadController = UploadController.instance;

  late final AudioPlayerManager pmFeed; // bubbles / feed
  late final AudioPlayerManager pmDraft; // input mini-player
  // Chat state
  final ScrollController _scroll = ScrollController();
  final TextEditingController _text = TextEditingController();

  // Recording
  fs.FlutterSoundRecorder recorder = fs.FlutterSoundRecorder();
  bool recorderInitiated = false;
  bool isRecording = false;
  int sec = 0;
  Timer? timer;
  static const int maxSec = 60;
  String? _draftPath; // just-recorded voice note in input
  String? webRecordingPath;

  WebRecorder? webRecorder;

  // UI helpers
  bool get _showMic => _text.text.trim().isEmpty && !isRecording;

  /// ----- Recorder init (idempotent) -----
  Future<void> _initRecorder() async {
    if (recorderInitiated) return;

    if (!kIsWeb) {
      //Only request this on mobile
      final status = await Permission.microphone.request();
      await Permission.manageExternalStorage.request();

      if (status != PermissionStatus.granted) {
        debugPrint('Microphone permission is not granted');
      }

      recorder = fs.FlutterSoundRecorder();
      await recorder.openRecorder();
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
    recorderInitiated = true;
  }

  /// ----- Start recording -----
  Future<void> _startRecording() async {
    if (isRecording) return;

    if (kIsWeb) {
      try {
        webRecorder ??=
            wr.WebRecorderImpl(); // comes from the conditional import
        await webRecorder!.start();

        //        await recordWebAudio();

        // flip UI right away so you see the timer/stop/trash
        setState(() {
          isRecording = true;
          sec = 0;
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
      await recorder.startRecorder(toFile: filePath, codec: fs.Codec.aacADTS);
      setState(() {
        isRecording = true;
        sec = 0;
        _draftPath = null;
      });
    }

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!isRecording) {
        t.cancel();
        return;
      }
      setState(() => sec++);
      if (sec >= maxSec) {
        if (kIsWeb) {
          await stopWebAudioRecording(autoplay: true);
        } else {
          await stopLocalAudioRecording(autoplay: true);
        }
      }
    });
  }

  Future<String?> stopWebAudioRecording({bool autoplay = true}) async {
    if (!isRecording || webRecorder == null) return _draftPath;

    final url = await webRecorder!.stop(); // blob: URL
    timer?.cancel();

    setState(() {
      isRecording = false;
      sec = 0;
      _draftPath = url; // set after it's ready
    });

    return url;
  }

  /// ----- Stop recording (returns local path) -----
  Future<String?> stopLocalAudioRecording({bool autoplay = true}) async {
    if (!isRecording) return _draftPath;

    final path = await recorder.stopRecorder(); // may be null in some builds
    timer?.cancel();

    setState(() {
      isRecording = false;
      sec = 0;
      _draftPath = path;
    });

    // Autoplay the draft in the input
    if (autoplay && path != null) {
      await pmFeed.stop(); // stop bubbles
      await pmDraft.setSource(path, isLocal: true);
      await pmDraft.play();
      chatController.activeAudioIdString.value = null;
    }
    return path;
  }

  /// ----- Discard the draft VN -----
  Future<void> _discardDraft() async {
    // Stop the draft preview player
    await pmDraft.stop();

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
      isRecording = false;
      sec = 0;
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
    await pmDraft.stop(); // stop input preview
    await pmFeed.stop(); // stop any bubble playback
    chatController.activeAudioIdString.value = null;

    // 2) Create optimistic message
    final temp = Message(
      messageId: null,
      chatId: chatController.chatId!.value,
      senderId: myId,
      senderType: consultant,
      message: _draftPath,
      // local path (mobile) or blob: URL (web)
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
          CustomSnackBar.errorSnackBar(
              'Nothing to upload. Please record again.');
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
                // server URL
                messageType: map['message_type'] as String?,
                // 'audio'
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
                  webRecorder?.dispose(); // revokes object URL on web
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
    pmFeed = AudioPlayerManager();
    pmDraft = AudioPlayerManager();

    _text.addListener(() => setState(() {}));
    _initRecorder();

    // initial data

    chatController.getChatInfo();
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
    pmFeed.onComplete(() {
      chatController.activeAudioIdString.value = null;
    });

    // Optional: when the draft preview finishes, you may want to refresh the
    // input UI (e.g., to flip the play icon back). Not strictly required.
    pmDraft.onComplete(() {
      setState(() {}); // safe no-op if your input depends on pmDraft streams
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    timer?.cancel();
    _text.dispose();
    pmFeed.dispose();
    pmDraft.dispose();
    recorder.closeRecorder();
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
                    child: Messages(
                        scroll: _scroll, pmFeed: pmFeed),
                  ),

                  // Input bar

                  SafeArea(
                    top: false,
                    child: InputBar(
                      text: _text,
                      isRecording: isRecording,
                      sec: sec,
                      showMic: _showMic,
                      draftPath: _draftPath,
                      pm: pmDraft,
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
