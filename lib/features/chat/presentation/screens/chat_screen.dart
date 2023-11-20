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
import 'package:tl_consultant/features/chat/presentation/screens/messages_list_widget.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/attachment_sheet.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/chat_item.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/replied_chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

part '../widgets/chat_app_bar.dart';

part '../widgets/input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.put(ChatController());
  final _recordingController = RecordingController()..onInit();

  bool micMode = true;
  bool get showMic => micMode && !_recordingController.isRecording.value;

  bool sendBtnClicked = false;

  _handleUpload() async {
    sendBtnClicked = true;

    await chatController.handleNewMsg(
        quotedMessage: chatController.replyMessage.value);
    sendBtnClicked = false;


    // if (chatController.showMic) return;
    // File? file;
    // bool upload = true;
    // if (chatController.isRecording) file = await chatController.recorder.stop();
    // if (!AppData.hasShownChatDisableDialog) {
    //   upload = await showDialog(
    //     context: context,
    //     builder: (_) => const DisableAccountDialog(),
    //   ) ??
    //       false;
    // }
    // if (chatController.isRecording) {
    //   //handleRecordingUpload(file, upload);
    // } else {
    //   chatController.handleTextUpload(upload);
    // }
  }

  @override
  void initState() {
    chatController.listenChannel();

    _recordingController.onInit();

    //re-instantiate the controller here to allow reuse after disposal
    chatController.textController = TextEditingController();

    chatController.textController.addListener(() {
      setState(() => micMode = chatController.textController.text.trim().isEmpty);
    });


    super.initState();
  }

  Future _startRecording() => _recordingController.record();

  Future _stopRecording() async {
    await _recordingController.stop();
    if (_recordingController.localAudioPath != null) {
      chatController
          .setVoiceFile(File(_recordingController.localAudioPath!));
    }
  }

  @override
  void dispose() {
    chatController.leaveChatChannel();
    _recordingController.dispose();
    chatController.textController.dispose();

    super.dispose();
  }
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

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  _TitleBar(),

                  //Expanded(child: Container(),),
                  Messages(messages: chatController.messages),

                  Obx(()=>
                      SafeArea(
                        top: false,
                        child: _InputBar(
                            chatWidget: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //display using an animation delete icon while recording
                                Visibility(
                                  visible: _recordingController.isRecording.value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: AnimatedCrossFade(
                                      duration: kTabScrollDuration,
                                      crossFadeState: _recordingController.isRecording.value
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      firstChild: IconButton(
                                        onPressed: () => showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (_) => const AttachmentSheet(),
                                        ),
                                        icon: Icon(
                                          Icons.attach_file,
                                          color: ColorPalette.green,
                                          size: 28,
                                        ),
                                      ),
                                      secondChild: IconButton(
                                        onPressed:(){
                                          _stopRecording();
                                        },
                                        icon: Icon(
                                          TranquilIcons.trash,
                                          color: ColorPalette.green,
                                          size: 27,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //Typing text
                                Expanded(
                                  child: Builder(builder: (context) {
                                    if (_recordingController.isRecording.value) {
                                      return Padding(
                                          padding: const EdgeInsets.only(left: 4, bottom: 13),
                                          child: Obx(()=>Text(
                                            _recordingController.time.value,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )));
                                    }
                                    return TextField(
                                      minLines: 1,
                                      maxLines: 5,
                                      controller: chatController.textController,
                                      textInputAction: TextInputAction.newline,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: const InputDecoration(
                                        filled: false,
                                        hintText: 'Type something...',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 4,
                                        ),
                                      ),
                                    );
                                  }),
                                ),

                                SwipeableWidget(
                                  maxOffset: 32,
                                  enabled: showMic,
                                  canLongPress: true,
                                  resetOnRelease: true,
                                  swipedWidget: const Icon(Icons.mic, color: ColorPalette.red),
                                  onStateChanged: (isActive) {
                                    isActive = true;
                                    if (showMic && isActive){
                                      //print("RECORDER STARTED");
                                      _startRecording();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: kThemeChangeDuration,
                                    padding: const EdgeInsets.all(6),
                                    margin:
                                    EdgeInsets.only(
                                        right: _recordingController.isRecording.value ? 6 : 8,
                                        bottom: 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorPalette.green,
                                      border: _recordingController.isRecording.value
                                          ? Border.all(color: ColorPalette.blue, width: 2)
                                          : null,
                                    ),
                                    child: GestureDetector(
                                      onTap: sendBtnClicked ? null : _handleUpload,
                                      child: AnimatedCrossFade(
                                        duration: kThemeChangeDuration,
                                        crossFadeState: showMic
                                            ? CrossFadeState.showSecond
                                            : CrossFadeState.showFirst,
                                        firstChild: Padding(
                                          padding: _recordingController.isRecording.value
                                              ? const EdgeInsets.fromLTRB(3, 1, 2, 1)
                                              : const EdgeInsets.fromLTRB(4, 3, 2, 3),
                                          child: const Icon(
                                            Icons.send,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                        secondChild: const Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            )
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
