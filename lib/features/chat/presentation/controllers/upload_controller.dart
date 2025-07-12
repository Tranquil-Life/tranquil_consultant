import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/main.dart';

class UploadController extends GetxController {
  static UploadController instance = Get.find();

  ChatController chatController = Get.put(ChatController());

  ChatRepoImpl chatRepo = ChatRepoImpl();
  MediaRepoImpl mediaRepo = MediaRepoImpl();

  var uploading = false.obs;

  handleTextUpload({
    required int chatId,
    required String message,
    Message? quotedMessage,
    required int clientID}) async {
    if (message.isEmpty) return;

    final chatController = ChatController.instance;


    chatController.messageType.value = MessageType.text.toString();

    Either either = await chatRepo.sendChat(
      chatId: chatId,
      message: message,
      messageType: strMsgType(chatController.messageType.value),
      parentId: quotedMessage!.messageId,
      caption: null,
      clientId: clientID,
    );

    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()), (r) {
      //TODO: Comment this and put it outside the either method
      uploading.value = false;

      // var messageMap = r['data'];
      var messageMap = r;

      var messageObj = Message(
        messageId: messageMap['id'],
        chatId: messageMap['chat_id'],
        senderId: messageMap['sender_id'],
        parentId: messageMap['parent_id'],
        senderType: messageMap['sender_type'],
        message: messageMap['message'],
        messageType: messageMap['message_type'],
        caption: messageMap['caption'],
        quoteMessage: null,
        read: null,
        createdAt: DateTime.parse(messageMap['created_at']),
        updatedAt: DateTime.parse(messageMap['updated_at']),
      );

      ChatController.instance.messages.insert(0, messageObj);

      update();
    });
  }

  Future handleVoiceNoteUpload({File? file, Message? quotedMessage}) async {
    if (file == null) return;

    var uploaded = false;
    var storageUrl = "";

    chatController.messageType.value = MessageType.audio.toString();

    debugPrint("handleVoiceNoteUpload: upload recording: $file");

    //TODO: Uncomment and modify to upload to Firebase storage
    // var result = await mediaRepo.uploadFileWithHttp(file, voiceNote);
    //
    // if (result.isRight()) {
    //   Map map = {};
    //   result.map((r) => map = r);
    //
    //   uploaded = true;
    //   storageUrl = map['data'].toString();
    // } else {
    //   result.leftMap((l) {
    //     CustomSnackBar.showSnackBar(
    //         context: Get.context!,
    //         title: "Error",
    //         message: l.message!,
    //         backgroundColor: ColorPalette.red);
    //   });
    // }
    //
    // if (uploaded) {
    //   await sendVnAsMessage(
    //       message: storageUrl,
    //       messageType: chatController.messageType.value,
    //       quotedMessage: quotedMessage);
    // }
  }

  Future sendVnAsMessage(
      {required String message,
      required String messageType,
      required Message? quotedMessage}) async {
    var data = {
      "chat_id": chatController.chatId?.value,
      "message": message,
      "message_type": strMsgType(messageType),
      "parent_id": quotedMessage!.messageId
    };
    var result = await chatRepo.sendChat(
        chatId: chatController.chatId?.value,
        message: message,
        messageType: strMsgType(messageType),
        parentId: quotedMessage.messageId,
        caption: null);

    debugPrint("sendVnAsMessage: VN to be sent as msg: $data");

    if (result.isRight()) {
      Map messageMap = {};
      result.map((r) => messageMap = r['data']);

      debugPrint("sendVnAsMessage: VN sent as msg: $messageMap");

      var messageObj = Message(
        messageId: messageMap['id'],
        chatId: messageMap['chat_id'],
        senderId: messageMap['sender_id'],
        parentId: messageMap['parent_id'],
        senderType: messageMap['sender_type'],
        message: messageMap['message'],
        messageType: "audio",
        // messageType: messageMap['message_type'],
        caption: messageMap['caption'],
        quoteMessage: null,
        read: null,
        createdAt: DateTime.parse(messageMap['created_at']),
        updatedAt: DateTime.parse(messageMap['updated_at']),
      );

      chatController.messages.insert(0, messageObj);

      uploadToFirestore(messageObj);
    } else {
      result.leftMap((l) {
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message!,
            backgroundColor: ColorPalette.red);
      });
    }
  }

  uploadToFirestore(Message message) async {
    // var room = firebaseFireStore
    //     .collection(chatsCollection)
    //     .doc(chatController.chatChannel.value);
    //
    // room
    //     .collection("chat_messages")
    //     .doc(message.messageId.toString())
    //     .set(message.toJson());
  }
}
