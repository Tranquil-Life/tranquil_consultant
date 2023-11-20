import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/data/models/message_model.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_recorder.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/main.dart';


class ChatController extends GetxController{
  static ChatController instance = Get.find();
  ChatRepoImpl repo = ChatRepoImpl();

  final scrollController = ItemScrollController();

  final textController = TextEditingController();
  // final recorder = AudioRecorder();

  bool micMode = true, isRecording = false;
  bool get showMic => micMode && !isRecording;

  StreamSubscription? isRecordingStreamSub;


  RxBool isExpanded = false.obs;
  RxString messageType = MessageType.text.toString().obs;
  Rx<Message> replyMessage = Message().obs;
  RxList<Message> messages = <Message>[].obs;

  Future handleUpload({Message? quotedMessage}) async {
    final message = textController.text.trim();
    if (message.isEmpty) return;
    var result = await repo.uploadChat(
        meetingId: DashboardController.instance.currentMeetingId.value,
        message: message,
        messageType: strMsgType(messageType.value),
        parentId: quotedMessage!.messageId ?? 0,
        caption: strMsgType(messageType.value)!="text" ? message : ""
    );

    if(result.isRight()){
      textController.clear();

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Success",
          message: "Success",
          backgroundColor: ColorPalette.green);

      Map messageMap = {};
      result.map((r) => messageMap = r);
      var messageType = messageMap['message_type'];

      // await sendMessage(
      //   meetingId: DashboardController.instance.currentMeetingId.value,
      //   messageId: messageMap['id'],
      //   message: messageMap['message'],
      //   messageType: messageType,
      //   replyMessage: quotedMessage,
      //   userType: messageMap['user_type'],
      //   caption: messageType!="text" ? message : null,
      // );

      replyMessage.value = Message();
      update();
    }
    else{
      result.leftMap((l){
        print(l.message);
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message!,
            backgroundColor: ColorPalette.red);
      });
    }
    isExpanded.value = false;

    textController.clear();
  }

  Future handleRecordingUpload(File? file, bool upload) async {
    if (file == null || !upload) return;

    // context.read<ChatBloc>().add(AddMessage(
    //       Message(isSent: false, type: MessageType.audio, data: file.path,),
    //     ));
  }

  @override
  void onClose() {
    isExpanded.value = false;
    super.onClose();
  }
}