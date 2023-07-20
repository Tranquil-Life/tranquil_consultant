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

  RxString messageReaction = "".obs;
  RxBool isExpanded = false.obs;
  RxInt parentId = 0.obs;
  RxBool hasCaption = false.obs;

  RxString messageType = MessageType.text.toString().obs;

  var quoteMsg = "".obs;

  RxList<Message> messages = <Message>[].obs;
  List<Message> tempMessages = [];

  List res = [];

  getChatMessages() async{
    var participant = {
      "id": userDataStore.user['id'],
      "display_name": "${userDataStore.user['f_name']} ${userDataStore.user['l_name']}",
      "user_type": consultant
    };

    DocumentReference documentReference = firebaseFireStore
        .collection(MEETING_COLLECTION).doc(DashboardController.instance.currentMeetingId.value.toString());

    try{
      await documentReference.get().then((snapshot) async{
        if(snapshot.exists){

          Map map = snapshot.data() as Map;
          if(!map.containsKey("participants")){
            await firebaseFireStore
                .collection(MEETING_COLLECTION)
                .doc(DashboardController.instance.currentMeetingId.value.toString())
                .update({
              'participants': [participant],
              'updated_at': FieldValue.serverTimestamp()
            });
          }
          else{
            res = snapshot.get("participants");
            bool exists = true;
            for (var element in res) {

              if(element['display_name'] != participant['display_name']){
                exists = false;
              }else{
                exists = true;
              }
            }

            if(exists == false){
              res.add(participant);

              await firebaseFireStore
                  .collection(MEETING_COLLECTION)
                  .doc(DashboardController.instance.currentMeetingId.value.toString())
                  .update({
                'participants': res,
                'updated_at': FieldValue.serverTimestamp(),
              });
            }
          }

          firebaseFireStore
              .collection(MEETING_COLLECTION)
              .doc(DashboardController.instance.currentMeetingId.value.toString())
              .collection("messages")
              .orderBy('created_at', descending: true)
              .snapshots()
              .listen((event) async{
            res.clear();

            res = await documentReference.get().then((value) => (value.data() as Map)['participants']);

            messages.value ??= <Message>[];
            messages.clear();
            tempMessages.clear();
            tempMessages.addAll(event.docs.map((e) => MessageModel.fromDocumentSnapshot(doc: e)));

            for (var element in tempMessages) {
              Map<String, dynamic> map = <String, dynamic>{
                "id": element.id,
                "from": element.from,
                "display_name": getClientName().toString(),
                'meeting_id':element.meetingId,
                "user_type": element.userType,
                'message':element.message,
                'message_type':element.messageType,
                'caption':element.caption,
                'parent_id':element.parentId,
                'parent_message':element.parentMessage,
                'created_at': element.createdAt,
              };

              messages.add(MessageModel.fromJson(map));
            }
            update();
          });
        }

      });
    }catch (error) {
      CustomSnackBar.showSnackBar(
        context: Get.context,
        title: "Error getting messages",
        message: error.toString(),
        backgroundColor: ColorPalette.red,
      );
    }
  }

  String getClientName(){
    String name = "";
    for (var i in res) {
      if(i['user_type']==client){
        name = i['display_name'];

        print(i);
      }
    }

    print("$name");

    return name;
  }

  Future handleTextUpload() async {
    final message = textController.text.trim();
    if (message.isEmpty) return;
    var result = await repo.uploadChat(
        meetingId: DashboardController.instance.currentMeetingId.value,
        message: message,
        messageType: strMsgType(messageType.value),
        parentId: parentId.value,
        caption: hasCaption.value ? message : ""
    );

    if(result.isRight()){
      Map messageMap = {};
      result.map((r) => messageMap = r);

      sendMessage(
        meetingId: DashboardController.instance.currentMeetingId.value,
        userType: messageMap['user_type'],
        messageId: messageMap['id'],
        message: message,
        messageType: messageMap['message_type'],
        parentId: messageMap['parent_id'],
        parentMessage: quoteMsg.value,
        caption: hasCaption.value ? message : null,
      );
    }
    else{
      result.leftMap((l){
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message!,
            backgroundColor: ColorPalette.red);
      });
    }
    isExpanded.value = false;
    parentId.value = 0;
    quoteMsg.value = "";
    hasCaption.value = false;

    textController.clear();
  }

  Future sendMessage({
    required int meetingId,
    required int messageId,
    required String message,
    required String messageType,
    String? caption,
    int? parentId,
    String? parentMessage,
    required String userType,
  }) async{
    try{
      var messageObject = Message(
        id: messageId,
        meetingId: meetingId,
        parentId: parentId ?? 0,
        parentMessage: parentMessage ?? "",
        from: userDataStore.user['id'],
        message: message.trim(),
        caption: caption ?? "",
        userType: userType,
        messageType: messageType,
        createdAt: DateTime.now(),
      );

      update();

      var room = firebaseFireStore
          .collection(MEETING_COLLECTION)
          .doc(meetingId.toString());

      room.collection("messages").doc(messageId.toString())
          .set(messageObject.toJson());

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
    messageReaction.value = "";
    isExpanded.value = false;
    super.onClose();
  }
}