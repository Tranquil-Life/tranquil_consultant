import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/data/models/message_model.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_recorder.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';


class ChatController extends GetxController{
  static ChatController instance = Get.find();
  ChatRepoImpl repo = ChatRepoImpl();

  final scrollController = ItemScrollController();

  final textController = TextEditingController();
  final recorder = AudioRecorder();

  bool micMode = true, isRecording = false;

  bool get showMic => micMode && !isRecording;

  StreamSubscription? isRecordingStreamSub;

  RxString messageReaction = "".obs;
  RxBool isExpanded = false.obs;
  RxInt parentId = 0.obs;
  RxBool hasCaption = false.obs;

  RxString messageType = MessageType.text.toString().obs;

  var quoteMsg = "".obs;

  final chatsStreamController = StreamController<List<Message>>.broadcast();
  Stream<List<Message>> get chatStream => chatsStreamController.stream;

  Future getMessages() async{
    var result = await repo.getChats(meetingId: DashboardController.instance.ongoingMeetingId.value);
    if(result.isRight()){
      List<Message> messages = [];

      result.map((r){
        if((r as List).isEmpty){
          chatsStreamController.sink.add(messages);
        }else{
          for (var element in r) {
            Message message = MessageModel.fromJson(element);
            messages.add(message);

            chatsStreamController.sink.add(messages);
          }
        }
      });


    }else{
      result.leftMap((l)
      => debugPrint("Error: ${l.message}")
        // CustomSnackBar.showSnackBar(
        //     context: Get.context!,
        //     title: "Error",
        //     message: l.message!,
        //     backgroundColor: ColorPalette.red)
      );
    }
  }

  Future handleTextUpload() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    var result = await repo.uploadChat(
        meetingId: DashboardController.instance.ongoingMeetingId.value,
        message: text,
        messageType: strMsgType(messageType.value),
        parentId: parentId.value,
        caption: hasCaption.value ? text : ""
    );

    if(result.isRight()){
      //..
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
    parentId.value = 0;
    hasCaption.value = false;

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
    messageReaction.value = "";
    isExpanded.value = false;
    super.onClose();
  }
}