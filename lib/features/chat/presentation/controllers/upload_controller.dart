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
  static UploadController get instance => Get.find();

  final chatController = ChatController.instance;

  ChatRepoImpl chatRepo = ChatRepoImpl();
  MediaRepoImpl mediaRepo = MediaRepoImpl();

  var storageUrl = "";
  var uploaded = false;

  var uploading = false.obs;


  Future<void> handleTextUpload({
    required int chatId,
    required String message,
    Message? quotedMessage,
    required int clientID,
  }) async {
    if (message.isEmpty) return;

    chatController.messageType.value = MessageType.text.toString();

    // Build payload safely: don't send parentId if null
    final either = await chatRepo.sendChat(
      chatId: chatId,
      message: message,
      messageType: strMsgType(chatController.messageType.value),
      parentId: quotedMessage?.messageId, // ✅ null-safe
      caption: null,
      eventName: 'new-message',
      channel: chatController.myChannel.channelName,
    );

    either.fold(
          (l) => CustomSnackBar.errorSnackBar(l.message.toString()),
          (r) {
        uploading.value = false;

        // Some APIs return { data: {...} }, others return the object directly
        final map = (r is Map && r['data'] is Map) ? (r['data'] as Map) : (r as Map);

        // Safe time parsing
        final created = DateTime.tryParse('${map['created_at']}') ?? DateTime.now();
        final updated = DateTime.tryParse('${map['updated_at']}') ?? created;

        final msg = Message(
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

        // Insert into the *observable* list that your Obx uses
        chatController.messages.insert(0, msg);

        // If your Obx still doesn't react (e.g., you reassign 'messages' elsewhere), force it:
        chatController.messages.refresh(); // ✅ ensures rebuild

        // DO NOT call 'update()' here; it targets UploadController listeners, not the Obx on messages
      },
    );
  }


  Future handleVoiceNoteUpload({
    File? file,
    Message? quotedMessage,
    required int chatId,
    required int clientID,
  }) async {
    if (file == null) return;

    uploading.value = true;

    chatController.messageType.value = MessageType.audio.toString();

    debugPrint("handleVoiceNoteUpload: upload recording: $file");

    Either either = await mediaRepo.uploadFileWithHttp(file, "chat_audio");

    either.fold(
          (l) async {
        CustomSnackBar.errorSnackBar(l.message.toString());
        if (l.message.toString().toLowerCase() == "connection reset by peer") {
          Either either2 = await mediaRepo.uploadFileWithHttp(
            file,
            "chat_audio",
          );
          either2.fold(
                (l) => CustomSnackBar.errorSnackBar(l.message.toString()),
                (r) {
              uploaded = true;

              print("RESPONSE: $r");
              storageUrl = r['data']['secure_url'].toString();
            },
          );

          if (uploaded) {
            await sendVnAsMessage(
              message: storageUrl,
              messageType: chatController.messageType.value,
              quotedMessage: quotedMessage,
              chatId: chatId,
              clientID: clientID,
            );
          }

          uploading.value = false;
        }
      },
          (r) {
        uploaded = true;

        print("RESPONSE: $r");
        storageUrl = r['data']['secure_url'].toString();
      },
    );

    //
    if (uploaded) {
      await sendVnAsMessage(
        message: storageUrl,
        messageType: chatController.messageType.value,
        quotedMessage: quotedMessage,
        chatId: chatId,
        clientID: clientID,
      );
    }

    uploading.value = false;
  }

  Future sendVnAsMessage({
    required int chatId,
    required String message,
    required String messageType,
    required Message? quotedMessage,
    required int clientID,
  }) async {
    if (message.isEmpty) return;

    chatController.messageType.value = MessageType.audio.toString();

    Either either = await chatRepo.sendChat(
      chatId: chatId,
      message: message,
      messageType: strMsgType(chatController.messageType.value),
      parentId: quotedMessage!.messageId,
      caption: null,
      eventName: 'new-message',
      channel: chatController.myChannel.channelName,
    );

    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()), (r) {
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

      chatController.messages.insert(0, messageObj);

      update();
    });
  }

}
