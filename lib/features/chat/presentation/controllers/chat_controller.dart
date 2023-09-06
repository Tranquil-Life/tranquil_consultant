import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final recorder = AudioRecorder();

  bool micMode = true, isRecording = false;
  bool get showMic => micMode && !isRecording;

  StreamSubscription? isRecordingStreamSub;


  RxBool isExpanded = false.obs;
  RxString messageType = MessageType.text.toString().obs;
  Rx<Message> replyMessage = Message().obs;
  RxList<Message> messages = <Message>[].obs;

  getChatMessages() async{
    var participant = {
      "id": userDataStore.user['id'],
      "display_name": "${userDataStore.user['f_name']} ${userDataStore.user['l_name']}",
      "user_type": consultant
    };
    await firebaseFireStore
        .collection(MEETING_COLLECTION)
        .doc(DashboardController.instance.currentMeetingId.value.toString())
        .get()
        .then((snapshot){
      if(snapshot.data().isNull){
        firebaseFireStore
            .collection(MEETING_COLLECTION)
            .doc(DashboardController.instance.currentMeetingId.value.toString())
            .set({
          'participants': [participant],
          'updated_at': FieldValue.serverTimestamp(),
          'meeting_id': DashboardController.instance.currentMeetingId.value
        });
      }else{
        if(snapshot.data()!.containsKey("participants")){
          for (var element in (snapshot.data()!["participants"] as List)) {
            if (element['display_name'] != participant['display_name']) {
              firebaseFireStore
                  .collection(MEETING_COLLECTION)
                  .doc(DashboardController.instance.currentMeetingId.value
                  .toString())
                  .update({
                'participants': [participant],
              });
            }
          }
        }
      }

      getMessages();
    });
  }

  getMessages(){
    firebaseFireStore
        .collection(MEETING_COLLECTION)
        .doc(DashboardController.instance.currentMeetingId.value.toString())
        .collection("messages")
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((event) async{
      messages.value ??= <Message>[];
      messages.clear();
      messages.addAll(event.docs.map((e) => MessageModel.fromJson(e.data())));

      update();
    });
  }

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

      await sendMessage(
        meetingId: DashboardController.instance.currentMeetingId.value,
        messageId: messageMap['id'],
        message: messageMap['message'],
        messageType: messageType,
        replyMessage: quotedMessage,
        userType: messageMap['user_type'],
        caption: messageType!="text" ? message : null,
      );

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

  Future sendMessage({
    required int meetingId,
    required int messageId,
    required String message,
    required String messageType,
    Message? replyMessage,
    String? caption,
    required String userType,
  }) async{
    var userId = userDataStore.user['id'];
    var username = "${userDataStore.user['f_name']} ${userDataStore.user['l_name']}";

    try{
      Map<String, dynamic> newMessage = {};

      if(replyMessage!.message !=null){
        newMessage = {
            'meeting_id':meetingId,
            "id": messageId,
            'message':message,
            'message_type':messageType,
            "from": userId,
            "display_name": username,
            "user_type": userType,
            'caption': caption,
            'reply_message': replyMessage.toJson(),
            "created_at": DateTime.now(),
        };
      }
      else{
        newMessage = {
          'meeting_id':meetingId,
          "id": messageId,
          'message':message,
          'message_type':messageType,
          "from": userId,
          "display_name": username,
          "user_type": userType,
          'caption': caption,
          'reply_message': null,
          "created_at": DateTime.now(),
        };
      }

      update();

      var room = firebaseFireStore
          .collection(MEETING_COLLECTION)
          .doc(meetingId.toString());

      room.collection("messages").doc(messageId.toString())
          .set(newMessage);
    }catch (error) {
      CustomSnackBar.showSnackBar(
        context: Get.context,
        title: "Message could not be sent",
        message: error.toString(),
        backgroundColor: ColorPalette.red,
      );
    }
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