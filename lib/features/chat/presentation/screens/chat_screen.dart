import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart' as av;
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_player_manager.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/message_controller.dart';
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
  final messageController = MessageController.instance;
  final uploadController = UploadController.instance;

  late final AudioPlayerManager pmFeed; // bubbles / feed
  late final AudioPlayerManager pmDraft; // input mini-player
  // Chat state
  final ScrollController _scroll = ScrollController();

  // Recording
  fs.FlutterSoundRecorder recorder = fs.FlutterSoundRecorder();
  bool recorderInitiated = false;
  bool isRecording = false;
  int sec = 0;
  Timer? timer;
  static const int maxSec = 60;
  String? webRecordingPath;

  WebRecorder? webRecorder;

  // UI helpers
  bool get _showMic =>
      messageController.text.text.trim().isEmpty && !isRecording;

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
        webRecorder ??= wr.WebRecorderImpl();
        await webRecorder!.start();

        setState(() {
          isRecording = true;
          sec = 0;
        });

        messageController.draftPath.value = null;
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
      });

      messageController.draftPath.value = null;
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
    if (!isRecording || webRecorder == null) return messageController.draftPath.value;

    final url = await webRecorder!.stop(); // blob: URL (may be null depending on impl)
    timer?.cancel();

    setState(() {
      isRecording = false;
      sec = 0;
    });

    messageController.draftPath.value = url; // FIX (outside setState is fine too)

    return url;
  }

  /// ----- Stop recording (returns local path) -----
  Future<String?> stopLocalAudioRecording({bool autoplay = true}) async {
    if (!isRecording) return messageController.draftPath.value;

    final path = await recorder.stopRecorder(); // can be null
    timer?.cancel();

    setState(() {
      isRecording = false;
      sec = 0;
    });

    messageController.draftPath.value = path;

    // Autoplay the draft in the input
    if (autoplay && path != null) {
      await pmFeed.stop(); // stop bubbles
      await pmDraft.setSource(path, isLocal: true);
      await pmDraft.play();
      messageController.activeAudioIdString.value = null;
    }

    return path;
  }

  /// ----- Discard the draft VN -----
  Future<void> _discardDraft() async {
    await pmDraft.stop();

    if (kIsWeb) {
      webRecorder?.dispose();
      webRecorder = null;
    } else {
      final path = messageController.draftPath.value;
      if (path != null) {
        final f = File(path);
        if (await f.exists()) await f.delete();
      }
    }

    setState(() {
      isRecording = false;
      sec = 0;
    });

    messageController.draftPath.value = null; // FIX (do NOT set wrapper null)
  }

  @override
  void initState() {
    super.initState();

    // instantiate the two players
    pmFeed = AudioPlayerManager();
    pmDraft = AudioPlayerManager();

    messageController.text.addListener(() => setState(() {}));
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
      messageController.activeAudioIdString.value = null;
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
                    child: Messages(scroll: _scroll, pmFeed: pmFeed),
                  ),

                  // Input bar
                  SafeArea(
                    top: false,
                    child: InputBar(
                      text: messageController.text,
                      isRecording: isRecording,
                      sec: sec,
                      showMic: _showMic,
                      pm: pmDraft,
                      onStartRecording: _startRecording,
                      onStopRecording: () => kIsWeb
                          ? stopWebAudioRecording(autoplay: true)
                          : stopLocalAudioRecording(autoplay: true),
                      onDiscardDraft: _discardDraft,
                      onSendText: () => messageController.sendText(
                          scroll: _scroll
                      ),
                      onSendDraft: () => messageController.sendDraft(
                          pmFeed: pmFeed,
                          pmDraft: pmDraft,
                          scroll: _scroll,
                          webRecorder: webRecorder),
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
