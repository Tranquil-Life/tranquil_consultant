import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/chat/data/models/message_model.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/main.dart';

class ChatController extends GetxController {
  final dashboardController = Get.put(DashboardController());

  ChatRepoImpl repo = ChatRepoImpl();

  TextEditingController textController = TextEditingController();
  RxList<Message> messages = <Message>[].obs;

  File? audioFile;

  var callRoomId = "".obs;
  RxSet<int> remoteIds = <int>{}.obs;
  var agoraToken = "".obs;
  String val = uidGenerator.v4();

  var loadingChatRoom = false.obs;
  RxBool isExpanded = false.obs;
  RxString messageType = MessageType.text.toString().obs;
  RxInt? chatId;
  var chatChannel = "".obs;
  Rx<Message> replyMessage = Message().obs;
  // Used to display loading indicators when _firstLoad function is running
  var lastMessageId = 0.obs;
  var isFirstLoadRunning = false.obs;
  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  RxBool allPagesLoaded = false.obs; // Flag to check if all pages are loaded
  //
  // List<QueryDocumentSnapshot> messagesDocs = <QueryDocumentSnapshot>[];
  //
  // //listen for changes on the firestore channel
  // listenChannel() {
  //   firebaseFireStore
  //       .collection(chatsCollection)
  //       .doc(chatChannel.value)
  //       .collection(messagesCollection)
  //       .orderBy('created_at',
  //           descending: true) // Assuming you have a timestamp field
  //       .limit(1)
  //       .snapshots()
  //       .listen((messagesSnapshot) {
  //     // Handle changes in the subcollection
  //     if (messagesSnapshot.docs.isNotEmpty) {
  //       Message message = MessageModel.fromDoc(messagesSnapshot.docs[0].data());
  //
  //       // Check if the message is not already in the list
  //       if (!messages.any((existingMessage) =>
  //           existingMessage.messageId == message.messageId)) {
  //         debugPrint('Latest Subcollection document data: ${message.message}');
  //
  //         if (message.senderId != UserModel.fromJson(userDataStore.user).id) {
  //           messages.insert(0, message);
  //         }
  //       }
  //     } else {
  //       debugPrint('No documents in the subcollection.');
  //     }
  //   });
  // }

  Future loadRecentMessages() async {
    if (chatId != null) {
      isFirstLoadRunning.value = true;
      var result = await repo.getRecentMessages(chatId: chatId!.value);

      if (result.isRight()) {
        result.map((r) {
          messages.clear();

          /**
         *
         * for (int i = 0; i < (r as List).length; i++) {
          Message message = MessageModel.fromJson(r[i]);
          if (!messages.any((existingMessage) =>
              existingMessage.messageId == message.messageId)) {
            messages.add(message);
          }
        }
         */

          var data = r['data'];
          for (int i = 0; i < (data as List).length; i++) {
            Message message = MessageModel.fromJson(data[i]);
            messages.add(message);
          }

          if (messages.isNotEmpty) {
            lastMessageId.value = messages[messages.length - 1].messageId!;
          } else {
            isFirstLoadRunning.value = false;
          }
        });

        //update(); // Notify listeners that the messages list has changed
        isFirstLoadRunning.value = false;
      } else {
        result.leftMap((l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message!,
            backgroundColor: ColorPalette.red));
      }

      update();
      isFirstLoadRunning.value = false;
      print(chatId!.value);
      // Additional logic related to chatId...
    } else {
      // Handle the case where chatId is null (optional).
      print('chatId is null');
    }
  }

  Future loadOlderMessages() async {
    isLoadMoreRunning.value = true;

    List<Message> newMessages = <Message>[];

    var result = await repo.getOlderMessages(
        chatId: chatId!.value, lastMessageId: lastMessageId.value);

    if (result.isRight()) {
      result.map((r) {
        for (int i = 0; i < (r['data'] as List).length; i++) {
          newMessages.add(MessageModel.fromJson(r[i]));
        }

        if (newMessages.isNotEmpty) {
          lastMessageId.value = newMessages[newMessages.length - 1].messageId!;

          messages.addAll(newMessages);
        } else {
          isLoadMoreRunning.value = false;
        }
      });
    }

    update();
    isLoadMoreRunning.value = false;
  }

  //Get specific chat history
  Future getChatInfo() async {
    loadingChatRoom.value = true;
    Either either = await repo.getChatInfo(
      consultantId: userDataStore.user['id'],
      clientId: 11,
      // clientId: dashboardController.clientId.value,
    );

    Map chatInfo = {};

    either.fold((l) {
      loadingChatRoom.value = false;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) {
      chatInfo = r['data'];

      chatId ??= RxInt(0);
      chatId!.value = chatInfo['id'];
      chatChannel.value = chatInfo['channel'];
    });

    await Future.delayed(Duration.zero);

    // await addChatToFirestore();
    await Future.delayed(const Duration(seconds: 1));

    loadRecentMessages();

    loadingChatRoom.value = false;
  }

  // Future addChatToFirestore() async {
  //   String documentId = chatChannel.value;
  //
  //   DocumentReference documentReference =
  //       firebaseFireStore.collection(chatsCollection).doc(documentId);
  //
  //   // Get the document snapshot
  //   DocumentSnapshot snapshot = await documentReference.get();
  //
  //   // Replace these with the fields and values you want to set
  //   Map<String, dynamic> fields = {
  //     'id': chatId!.value,
  //     'client_id': dashboardController.clientId.value,
  //     'consultant_id': UserModel.fromJson(userDataStore.user).id,
  //     'channel': chatChannel.value,
  //     'created_at': DateTimeExtension.now,
  //     'updated_at': DateTimeExtension.now
  //   };
  //
  //   try {
  //     if (!snapshot.exists) {
  //       // Add document to the top-level collection: chats
  //       await documentReference.set(fields);
  //
  //       debugPrint('Data added successfully!');
  //
  //       Get.toNamed(Routes.CHAT_SCREEN, arguments: chatId?.value);
  //     } else {
  //       Get.toNamed(Routes.CHAT_SCREEN, arguments: chatId?.value);
  //     }
  //   } catch (e) {
  //     debugPrint('Error adding data: $e');
  //   }
  // }

  setVoiceFile(File file) {
    audioFile = file;
    update();
  }

  @override
  void onInit() {
    loadRecentMessages();
    super.onInit();
  }

  @override
  void onClose() {
    // isExpanded.value = false;
    // chatId!.close(); // Dispose of the subscription

    super.onClose();
  }
}
