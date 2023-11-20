import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/laravel_echo/laravel_echo.dart';
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

  TextEditingController textController = TextEditingController();
  RxList<Message> messages = <Message>[].obs;

  File? audioFile;

  RxBool isExpanded = false.obs;
  RxString messageType = MessageType.text.toString().obs;
  RxInt? chatId;
  var chatChannel = "".obs;
  Rx<Message> replyMessage = Message().obs;

  getMessages() async{

  }

  void listenChannel(){
    LaravelEcho.instance.channel(chatChannel.value)
        .listen('.message.sent',
            (e){
          if(e is PusherEvent){
            if(e.data !=null){
              print("PUSHER DATA: ${jsonDecode(e.data!)}");

              Map map = jsonDecode(e.data!);

              messages.value ??= <Message>[];
              // messages.clear();
              messages.add(MessageModel.fromJson(map['chatMessages']));


              //update();
            }
          }
        }).error((err){
      print(err);
    });
  }

  void leaveChatChannel(){
    try{
      LaravelEcho.instance.leave(chatChannel.value);
    }catch(err){
      print(err);
    }
  }

  Future getChatInfo() async{
    var result = await repo.getChatInfo(
        consultantId: userDataStore.user['id'],
        clientId: DashboardController.instance.clientId.value
    );

    Map chatInfo = {};
    if(result.isRight()){
      result.map((r) => chatInfo = r);

      chatId ??= RxInt(0);

      chatId!.value = chatInfo['id'];
      chatChannel.value = chatInfo['channel'];

      print("CHAT_ID: $chatId\nCHAT_CHANNEL: ${chatChannel.value}");

    }

  }

  String get derivedMsgType {
    switch (MessageType.values.first) {
      case MessageType.image:
        return 'image';
      case MessageType.text:
        return 'text';
      case MessageType.video:
        return 'video';
      case MessageType.audio:
        return 'audio';
      default:
        return 'text';
    }
  }

  Future handleNewMsg({Message? quotedMessage}) async {
    final message = textController.text.trim();
    if (message.isEmpty) return;
    var result = await repo.sendChat(
        chatId: chatId?.value,
        message: message,
        messageType: derivedMsgType,
        parentId: quotedMessage!.messageId ?? null,
        caption: strMsgType(messageType.value)!="text" ? message : null
    );

    if(result.isRight()){
      textController.clear();

      print(messages);


      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Success",
          message: "Success",
          backgroundColor: ColorPalette.green);

      //var messageMap = {};
      // result.map((r) => messageMap = r);
      //
      // print("RESPONSE: $messageMap");

      update();
    }
    else{
      result.leftMap((l){
        print("FAILED: ERROR: ${l.message}");
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

  setVoiceFile(File file) {
    audioFile = file;
    update();
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
    chatId!.close(); // Dispose of the subscription

    super.onClose();
  }
}