import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/app_bar_button.dart';
import 'package:tl_consultant/core/global/custom_loader.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/services/formatters.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/agora_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/audio_player_manager.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/recording_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/messages_list_widget.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/attachment_sheet.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/chat_item.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/replied_chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/vn_dialog.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:vibration/vibration.dart';

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

  Future _startRecording() async {
    await _recordingController.record();
    setState(() {
      micMode = false;
    });

    startTimer();
  }

  Future _stopRecording() async {
    await _recordingController.stop();

    setState(() {});
    if (_recordingController.localAudioPath != null) {
      chatController.setVoiceFile(File(_recordingController.localAudioPath!));
    }

    debugPrint("Chat screen: stop recording: ${chatController.audioFile}");

    return chatController.audioFile!;
  }

  Future _uploadVn() async {
    var hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator!) {
      await Vibration.vibrate(duration: 2000, amplitude: 225);
    }

    chatController.audioFile = await _stopRecording();

    await UploadController().handleVoiceNoteUpload(
      file: chatController.audioFile,
      quotedMessage: chatController.replyMessage.value,
      chatId: chatId!,
      clientID: client!.id,
    );

    _recordingController.recordingDuration = 0;
  }


  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingController.recordingDuration += 1;
        print(_recordingController.recordingDuration);

        if (_recordingController.recordingDuration >= _maxRecordingDuration) {
          print("IT'S TIME: ${_recordingController.recordingDuration}");
          _timer?.cancel();
          _uploadVn();
          _recordingController.recordingDuration = 0;
        }
      });
    });
  }

  int? chatId;
  ClientUser? client;
  var arguments = <String, dynamic>{};

  @override
  void initState() {
    super.initState();

    var args = Get.arguments;
    arguments = args;
    chatId = args['chat_id'];
    client = args['client'];

    // Assign chatId to controller BEFORE loading messages
    chatController.chatId = RxInt(chatId!);

    // Now it's safe to load messages
    chatController.loadRecentMessages();

    print("INIT_STATE: ${chatController.messages}");

    print("CHAT_IDD: $chatId");
    chatController.initializePusher();

    _recordingController.onInit();
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
          Obx(() {
            if (_recordingController.time.value == "01:00") {
              _uploadVn();
            }

            return SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    _TitleBar(),

                    // Chat messages list
                    Expanded(
                        child: chatController.isFirstLoadRunning.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: ColorPalette.green))
                            : UnFocusWidget(
                                child: Messages(playerManager: AudioPlayerManager()),
                              )),

                    SafeArea(
                      top: false,
                      child: InputBar(
                        chatController: chatController,
                        recordingController: _recordingController,
                        startRecording: _startRecording,
                        stopRecording: _stopRecording,
                        showMic: showMic,
                        chatId: chatId,
                        uploadController: uploadController,
                        client: client!, uploadVn: _uploadVn,
                      ),
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
