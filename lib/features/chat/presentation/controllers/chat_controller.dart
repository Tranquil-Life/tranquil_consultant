import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
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
  // Used to display loading indicators when _firstLoad function is running
  var lastMessageId = 0.obs;
  var isFirstLoadRunning = false.obs;
  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  RxBool allPagesLoaded = false.obs; // Flag to check if all pages are loaded

  List<QueryDocumentSnapshot> messagesDocs = <QueryDocumentSnapshot>[];

  //listen for changes on the firestore channel
  listenChannel(){
    //messagesDocs.clear();

    firebaseFireStore
    .collection(chatsCollection)
    .doc(chatChannel.value)
    .collection(messagesCollection)
    .orderBy('created_at', descending: true)  // Assuming you have a timestamp field
    .limit(1)
    .snapshots()
    .listen((messagesSnapshot) { 
      // Handle changes in the subcollection
      if (messagesSnapshot.docs.isNotEmpty) {
        Message message = MessageModel.fromDoc(
          messagesSnapshot.docs[0].data());

        // Check if the message is not already in the list
        if (!messages.any((existingMessage) => existingMessage.messageId == message.messageId)) {
          debugPrint('Latest Subcollection document data: ${message.message}');

          if (message.senderId != UserModel.fromJson(userDataStore.user).id) {
            messages.insert(0, message);
          }
        }

        print("INSERTED: $messages");
        // Iterate through the documents in the subcollection
        // for (QueryDocumentSnapshot docSnapshot in messagesSnapshot.docs) {
        //   messagesDocs.add(docSnapshot);
        // }

        // Message message = MessageModel.fromDoc(messagesDocs[messagesDocs.length-1].data() as Map<String, dynamic>);

        // if(!(messages.contains(message))){
        //   debugPrint('Subcollection document data: ${message.message}');
          
        //   if(message.senderId! != UserModel.fromJson(userDataStore.user).id){
        //     messages.insert(0, message);
        //   }

        // }

      } else {
        debugPrint('No documents in the subcollection.');
      }
    });
  }

  leaveChatChannel(){
    //..
  }

  Future loadRecentMessages() async {
    isFirstLoadRunning.value = true;

    messages.clear();

    var result = await repo.getRecentMessages(chatId: chatId!.value);

    if (result.isRight()) {
      result.map((r) {
        for (int i = 0; i < (r as List).length; i++) {
          Message message = MessageModel.fromJson(r[i]);
          if (!messages.any((existingMessage) => existingMessage.messageId == message.messageId)) {
            messages.add(message);
          }
        }

        if (messages.isNotEmpty) {
          lastMessageId.value = messages[messages.length-1].messageId!;
        }else{
          isFirstLoadRunning.value = false;
        }

      });
    } else {
      result.leftMap((l) =>
          CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message!,
              backgroundColor: ColorPalette.red));
    }

    update();
    isFirstLoadRunning.value = false;
  }

  Future loadOlderMessages() async {
    isLoadMoreRunning.value = true;

    List<Message> newMessages = <Message>[];

    var result = await repo.getOlderMessages(chatId: chatId!.value, lastMessageId: lastMessageId.value);

    if (result.isRight()) {
      result.map((r) {
        for (int i = 0; i < (r as List).length; i++) {
          newMessages.add(MessageModel.fromJson(r[i]));
        }

        if (newMessages.isNotEmpty) {
          lastMessageId.value = newMessages[newMessages.length-1].messageId!;

          messages.addAll(newMessages);
        }else{
          isLoadMoreRunning.value = false;
        }

      });
    } else {
      // Handle error
    }

    update();
    isLoadMoreRunning.value = false;
  }

  //Get specific chat history
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

      await addChatToFirestore();  

    }else{
      result.leftMap((l) => print("LEFT: Error: ${l.message!} "));
    }

  }

  Future addChatToFirestore() async{
    String collection = chatsCollection;

    String documentId = chatChannel.value;

    DocumentReference documentReference = 
    firebaseFireStore.collection(collection).doc(documentId);

      // Get the document snapshot
    DocumentSnapshot snapshot = await documentReference.get(); 

    // Replace these with the fields and values you want to set
    Map<String, dynamic> fields = {
      'id': chatId!.value,
      'client_id': DashboardController.instance.clientId.value,
      'consultant_id': UserModel.fromJson(userDataStore.user).id,
      'channel': chatChannel.value,
      'created_at': DateTimeExtension.now,
      'updated_at': DateTimeExtension.now
    };

    try {
      if(!snapshot.exists){
        // Add document to the top-level collection: chats
        await FirebaseFirestore.instance.collection(collection).doc(documentId).set(fields);

        debugPrint('Data added successfully!');

        Get.toNamed(Routes.CHAT_SCREEN);

      }else{
        Get.toNamed(Routes.CHAT_SCREEN);

      }

    } catch (e) {
      debugPrint('Error adding data: $e');
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
    isExpanded.value = false;
    chatId!.close(); // Dispose of the subscription

    super.onClose();
  }
}