import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/video_call_view.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/main.dart';

class AgoraController extends GetxController {
  ChatRepoImpl repo = ChatRepoImpl();

  final dashboardController = Get.put(DashboardController());
  final chatController = Get.put(ChatController());

  var callRoomId = "".obs;
  RxSet<int> remoteIds = <int>{}.obs;
  var agoraToken = "".obs;
  String val = uidGenerator.v4();
  final now = DateTimeExtension.now;

  updateAgoraInfo() async {
    String documentId = chatController.chatChannel.value;

    callRoomId.value =
        "${val.substring(0, val.length - 28)}-${dashboardController.currentMeetingId}";

    // DocumentReference documentReference =
    //     firebaseFireStore.collection(chatsCollection).doc(documentId);

    await getAgoraToken();

    Map<String, dynamic> fields = <String, dynamic>{};
    fields = {
      'agora_channel': callRoomId.value,
    };

    // await documentReference.update(fields);

    navigateToCallView();
  }

  Future placeAgoraCall() async {
    //update Firebase DB with agoraChannel, token
    String documentId = chatController.chatChannel.value;

    // DocumentReference documentReference =
    //     firebaseFireStore.collection(chatsCollection).doc(documentId);
    //
    // // Get the document snapshot
    // DocumentSnapshot snapshot = await documentReference.get();

    // if (snapshot.exists) {
    //   Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    //
    //   if (data != null && data.containsKey("agora_channel")) {
    //     callRoomId.value = data['agora_channel'];
    //
    //     await getAgoraToken();
    //
    //     //Place call and update agora_call_status to calling...
    //     // var fields = {'agora_call_status': "calling..."};
    //
    //     // await documentReference.update(fields);
    //
    //     navigateToCallView();
    //
    //     debugPrint('Updated successfully!');
    //   } else {
    //     updateAgoraInfo(); //Update all agora fields
    //   }
    // }
  }

  Future joinAgoraCall({bool join = true}) async {
    if (!join) {
      await placeAgoraCall();
    } else {
      print("join call");

      //join call
      //get agoraChannel, and token
    }
  }

  Future getAgoraToken() async {
    //Tell backend dev to set expiry time of token to be the duration of the
    //meeting time left in seconds on the API

    //if agoratoken and channelId don't exist on the firebase DB
    //do this

    Either either = await repo.getAgoraToken(callRoomId.value);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red),
        (r) => agoraToken.value = r['data']);
  }

  navigateToCallView() => Get.to(const VideoCallView(
        isLocal: true,
      ));
}
