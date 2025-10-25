import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/app_bar_button.dart';
import 'package:tl_consultant/core/global/custom_loader.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/services/formatters.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/agora_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/audio_player_manager.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/recording_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/messages_list_widget.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/attachment_sheet.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/replied_chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/vn_dialog.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

part '../widgets/chat_app_bar.dart';

part '../widgets/input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = ChatController.instance;

  final uploadController = Get.put(UploadController());
  final _recordingController = RecordingController()..onInit();
  final AudioPlayerManager playerManager = AudioPlayerManager();

  bool micMode = true;

  bool get showMic => micMode && !_recordingController.isRecording.value;
  final int _maxRecordingDuration = 60; // in seconds
  Timer? _timer;

  int? chatId;
  ClientUser? client;
  String channel = "";
  var arguments = <String, dynamic>{};
  bool _isSmall = false;

  Future _startRecording() async {
    await _recordingController.record();
    setState(() {
      micMode = false;
    });

    startTimer();
  }

  Future _stopRecording() async {
    await _recordingController.stop();
    // no need to setState here unless some non-Rx UI depends on it
    if (_recordingController.localAudioPath != null) {
      chatController.setVoiceFile(File(_recordingController.localAudioPath!));
    }
    return chatController.audioFile!;
  }

  bool _isUploadingVn = false; // guard against double calls

  Future<void> _uploadVn() async {
    if (_isUploadingVn) return; // prevent duplicate uploads
    _isUploadingVn = true;

    try {
      // Stop and fetch the file
      final file = await _stopRecording(); // returns File? per your code
      if (file == null) {
        debugPrint('Voice note file is null; aborting upload.');
        return;
      }
      chatController.audioFile = file;

      // Validate IDs
      final id = chatId;
      final cl = client;
      if (id == null || cl?.id == null) {
        debugPrint('chatId/client.id is null; aborting upload.');
        return;
      }

      // Use the injected controller to avoid extra instances
      await uploadController.handleVoiceNoteUpload(
        file: chatController.audioFile,
        quotedMessage: chatController.replyMessage.value,
        chatId: id,
        clientID: cl!.id!,
      );

      // Reset the timer counter (RxInt -> use .value)
      _recordingController.recordingDuration.value = 0;

      // (Optional) restore mic UI state if you hide it during recording
      if (!mounted) return;
      setState(() {
        micMode = true;
      });
    } catch (e, st) {
      debugPrint('VN upload failed: $e\n$st');
    } finally {
      _isUploadingVn = false;
    }
  }


  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // 👇 No setState — only bump the Rx value
      _recordingController.recordingDuration.value++;
      if (_recordingController.recordingDuration.value >= _maxRecordingDuration) {
        _timer?.cancel();
        _uploadVn();
        _recordingController.recordingDuration.value = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Now it's safe to load messages
    chatController.loadRecentMessages();
    print("chnanel name before pusher initialisation: $channel");
    chatController.initializePusher(channel: channel);
    _recordingController.onInit();


    // // Trigger upload without rebuilding the whole screen
    // ever<String>(_recordingController.time, (t) {
    //   if (t == "01:00") {
    //     _uploadVn();
    //     _recordingController.recordingDuration.value = 0;
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isSmall = isSmallScreen(context);

    // If you need Get.arguments only on small screens, do it here
    final args = Get.arguments as Map<String, dynamic>?;
    if (_isSmall && args != null) {
      arguments = args;
      chatId = args['chat_id'] as int?;
      client = args['client'] as ClientUser?;
      channel = args['channel'] as String? ?? "";
    } else {
      client = chatController.rxClient.value;
      channel = chatController.chatChannel.value;
      chatController.initializePusher(channel: channel);
    }
  }

  @override
  void dispose() {
    //chatController.leaveChatChannel();
    _recordingController.dispose();
    chatController.onClose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/chat_bg.png'),
            fit: BoxFit.cover,
            color: Colors.black26,
            colorBlendMode: BlendMode.darken,
          ),

          // ⛔️ Don’t Obx-wrap the whole screen.
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  // Make this const if you can (see TitleBar below)
                  const TitleBar(),

                  // Chat messages list (only this part listens to chat Rx)
                  Expanded(
                    child: Obx(() {
                      return chatController.isFirstLoadRunning.value
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.green,
                        ),
                      )
                          : UnFocusWidget(
                        child: Messages(
                          playerManager: AudioPlayerManager(),
                        ),
                      );
                    }),
                  ),

                  // Input bar listens only to recording Rx where needed
                  SafeArea(
                    top: false,
                    child: InputBar(
                      chatController: chatController,
                      recordingController: _recordingController,
                      startRecording: _startRecording,
                      stopRecording: _stopRecording,
                      showMic: showMic,
                      uploadVn: _uploadVn,
                      uploadController: uploadController,
                      chatId: chatController.chatId?.value,
                      client: client,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
