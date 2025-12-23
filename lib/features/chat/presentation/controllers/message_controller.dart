import 'dart:io';

import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_player_manager.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/webrecorder/web_recorder.dart';


class MessageController extends GetxController {
  static MessageController get instance => Get.find();

  final RxnString activeAudioIdString = RxnString();
  final TextEditingController text = TextEditingController();

  final RxnString draftPath = RxnString();

  /// ----- Send text -----
  Future<void> sendText({required ScrollController scroll}) async {
    final chatController = ChatController.instance;
    final uploadController = UploadController.instance;

    final txt = text.text.trim();
    if (txt.isEmpty) return;

    text.clear();

    // 1️⃣ Create a temporary optimistic message
    final temp = Message(
      messageId: null,
      chatId: chatController.chatId!.value,
      senderId: myId,
      senderType: consultant,
      message: txt,
      messageType: 'text',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Insert at top (since reverse:true)
    chatController.messages.insert(0, temp);
    scrollToEnd(scroll);

    try {
      // 2️⃣ Call the API to send the actual message
      final either = await uploadController.chatRepo.sendChat(
        chatId: chatController.chatId!.value,
        message: txt,
        messageType: strMsgType(MessageType.text.toString()),
        parentId: null,
        caption: null,
        eventName: 'new-message',
        channel: chatController.myChannel.channelName,
      );

      // 3️⃣ Handle success or failure
      either.fold(
        (l) {
          // Error → remove optimistic bubble and show error
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar(l.message.toString());
        },
        (r) {
          // Success → build final Message object
          final map =
              (r is Map && r['data'] is Map) ? (r['data'] as Map) : (r as Map);

          final created =
              DateTime.tryParse('${map['created_at']}') ?? DateTime.now();
          final updated = DateTime.tryParse('${map['updated_at']}') ?? created;

          final serverMsg = Message(
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

          // 4️⃣ Replace temp with server message
          final index = chatController.messages.indexOf(temp);
          if (index != -1) {
            chatController.messages[index] = serverMsg;
          } else {
            chatController.messages.insert(0, serverMsg);
          }

          chatController.messages.refresh();
          scrollToEnd(scroll);
        },
      );
    } catch (e) {
      // 5️⃣ If API throws, remove the temp and show feedback
      chatController.messages.remove(temp);
      CustomSnackBar.errorSnackBar('Failed to send message: $e');
    }
  }

  Future<void> sendDraft({
    required AudioPlayerManager pmFeed,
    required AudioPlayerManager pmDraft,
    required ScrollController scroll,
    WebRecorder? webRecorder
  }) async {
    final chatController = ChatController.instance;
    final uploadController = UploadController.instance;

    final currentDraft = draftPath.value;
    if (currentDraft == null) return;


    // 1) Ensure no other audio is playing
    await pmDraft.stop(); // stop input preview
    await pmFeed.stop(); // stop any bubble playback
    activeAudioIdString.value = null;

    // 2) Create optimistic message
    final temp = Message(
      messageId: null,
      chatId: chatController.chatId!.value,
      senderId: myId,
      senderType: consultant,
      message: currentDraft,
      // local path (mobile) or blob: URL (web)
      messageType: 'audio',
      caption: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    chatController.messages.insert(0, temp);
    scrollToEnd(scroll);

    // 3) Kick off upload
    try {
      dz.Either uploadEither;

      if (kIsWeb) {
        // Take bytes BEFORE disposing the recorder
        final bytes = await webRecorder?.takeBytes();
        if (bytes == null) {
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar(
              'Nothing to upload. Please record again.');
          return;
        }
        final filename = 'vn_${DateTime.now().millisecondsSinceEpoch}.webm';
        uploadEither = await uploadController.mediaRepo.uploadBytesWithHttp(
          bytes,
          filename,
          "chat_audio",
          mediaType: 'audio',
          mediaSubType: 'webm',
        );
      } else {
        final f = File(currentDraft);
        if (!await f.exists()) {
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar('Recorded file missing.');
          return;
        }
        uploadEither = await uploadController.mediaRepo.uploadFileWithHttp(
          f,
          "chat_audio",
        );
      }

      // 4) Handle upload result
      await uploadEither.fold(
        (l) async {
          chatController.messages.remove(temp);
          CustomSnackBar.errorSnackBar(l.message.toString());
        },
        (r) async {
          final secureUrl = r['data']?['secure_url']?.toString();
          if (secureUrl == null || secureUrl.isEmpty) {
            chatController.messages.remove(temp);
            CustomSnackBar.errorSnackBar('Upload returned an invalid URL.');
            return;
          }

          // 5) Send the uploaded URL as a message
          final either = await uploadController.chatRepo.sendChat(
            chatId: chatController.chatId!.value,
            message: secureUrl,
            messageType: strMsgType(MessageType.audio.toString()),
            parentId: null,
            caption: null,
            eventName: 'new-message',
            channel: chatController.myChannel.channelName,
          );

          either.fold(
            (l) {
              chatController.messages.remove(temp);
              CustomSnackBar.errorSnackBar(l.message.toString());
            },
            (res) {
              final map = (res is Map && res['data'] is Map)
                  ? (res['data'] as Map)
                  : (res as Map);

              final created =
                  DateTime.tryParse('${map['created_at']}') ?? DateTime.now();
              final updated =
                  DateTime.tryParse('${map['updated_at']}') ?? created;

              final serverMsg = Message(
                messageId: map['id'] as int?,
                chatId: map['chat_id'] as int?,
                senderId: map['sender_id'] as int?,
                parentId: map['parent_id'] as int?,
                senderType: map['sender_type'] as String?,
                message: map['message'] as String?,
                // server URL
                messageType: map['message_type'] as String?,
                // 'audio'
                caption: map['caption'] as String?,
                read: (map['read'] as List?)?.cast<Map<String, dynamic>>(),
                createdAt: created,
                updatedAt: updated,
              );

              // Replace optimistic
              final idx = chatController.messages.indexOf(temp);
              if (idx != -1) {
                chatController.messages[idx] = serverMsg;
              } else {
                chatController.messages.insert(0, serverMsg);
              }
              chatController.messages.refresh();

              // 6) Clean local draft & recorder
              draftPath.value = null;
              if (kIsWeb) {
                webRecorder?.dispose(); // revokes object URL on web
                webRecorder = null;
              }

              scrollToEnd(scroll);
            },
          );
        },
      );
    } catch (e) {
      chatController.messages.remove(temp);
      CustomSnackBar.errorSnackBar('Upload failed: $e');
    }
  }

  void scrollToEnd(ScrollController scroll) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      scroll.animateTo(
        0.0, // because reverse:true
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void onClose() {
    text.dispose();
    super.onClose();
  }
}
