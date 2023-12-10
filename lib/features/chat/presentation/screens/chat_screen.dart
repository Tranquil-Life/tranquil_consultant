import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/tranquil_icons.dart';
import 'package:tl_consultant/app/presentation/widgets/app_bar_button.dart';
import 'package:tl_consultant/app/presentation/widgets/swipeable.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/services/formatters.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/recording_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/messages_list_widget.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/attachment_sheet.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/chat_item.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/replied_chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/vn_dialog.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:vibration/vibration.dart';

part '../widgets/chat_app_bar.dart';

part '../widgets/input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    final chatController = Get.put(ChatController());
  final uploadController = Get.put(UploadController());
  final _recordingController = RecordingController()..onInit();

  bool micMode = true;
  bool get showMic => micMode && !_recordingController.isRecording.value;

  Future _startRecording() => _recordingController.record();

  Future _stopRecording() async {
    await _recordingController.stop();
    if (_recordingController.localAudioPath != null) {
      chatController
          .setVoiceFile(File(_recordingController.localAudioPath!));
    }

    return chatController.audioFile!;
  }

  Future _uploadVn() async{
    var hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator!) {
      await Vibration.vibrate(duration: 4000, amplitude: 225);
    }

    chatController.audioFile = await _stopRecording();

    await UploadController().handleVoiceNoteUpload(
        file: chatController.audioFile,
        quotedMessage: chatController.replyMessage.value);
  }

  @override
  void initState() {
    chatController.onInit();
    chatController.listenChannel();

    _recordingController.onInit();

    //re-instantiate the controller here to allow reuse after disposal
    chatController.textController = TextEditingController();

    chatController.textController.addListener(() {
      setState(() => micMode = chatController.textController.text.trim().isEmpty);
    });


    super.initState();
  }

  @override
  void dispose() {
    //chatController.leaveChatChannel();
    _recordingController.dispose();
    chatController.textController.dispose();
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


          Obx((){
            if (_recordingController.time.value == "01:00") {
              _uploadVn();
            }

            return SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    const _TitleBar(),


                    // Chat messages list
                   Expanded(child: chatController.isFirstLoadRunning.value
                       ?
                   const Center(child: CircularProgressIndicator(color: ColorPalette.green))
                       :
                   const UnFocusWidget(
                     child: Messages(),
                   )),
                    SafeArea(
                      top: false,
                      child: _InputBar(
                          chatController: chatController,
                          recordingController: _recordingController,
                          startRecording: _startRecording,
                          stopRecording: _stopRecording,
                          showMic: showMic
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
