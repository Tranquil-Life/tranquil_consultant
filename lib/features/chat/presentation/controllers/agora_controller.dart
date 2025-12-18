import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/video_call_view.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

class AgoraController extends GetxController {
  static AgoraController get instance => Get.find<AgoraController>();

  ChatRepoImpl repo = ChatRepoImpl();

  // final dashboardController = DashboardController.instance;

  RxSet<int> remoteIds = <int>{}.obs;
  var agoraToken = "".obs;
  final now = DateTimeExtension.now;

  Future joinAgoraCall() async {
    await getAgoraToken();
  }

  Future getAgoraToken() async {

    //Tell backend dev to set expiry time of token to be the duration of the
    //meeting time left in seconds on the API

    //if agora token and channelId don't exist on the firebase DB
    //do this
    Either either = await repo.getAgoraToken(
       ChatController.instance.chatChannel.value, DashboardController.instance.currentMeetingId.value);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()),
            (r) {
          agoraToken.value = r['data']['token'];

          navigateToCallView();
        }

    );
  }

  navigateToCallView(){
    if (kIsWeb) {
      // Get.to(const WebVideoCallView());
    } else {
      Get.to(const VideoCallView(
        isLocal: true,
      ));
    }
  }
}
