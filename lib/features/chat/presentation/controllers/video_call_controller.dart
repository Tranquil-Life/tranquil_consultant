import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/chat/data/models/room_model.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/video_call_view.dart';
import 'package:tl_consultant/features/chat/presentation/screens/web_video_call_view.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class VideoCallController extends GetxController {
  static VideoCallController get instance => Get.find<VideoCallController>();

  ChatRepoImpl repo = ChatRepoImpl();

  RxSet<int> remoteIds = <int>{}.obs;
  var agoraToken = "".obs;
  final now = DateTimeExtension.now;
  RxMap roomData = {}.obs;

  Future joinAgoraCall() async {
    await getAgoraToken();
  }

  Future getAgoraToken() async {
    //Tell backend dev to set expiry time of token to be the duration of the
    //meeting time left in seconds on the API

    //if agora token and channelId don't exist on the firebase DB
    //do this
    Either either = await repo.getAgoraToken(
        ChatController.instance.chatChannel.value,
        DashboardController.instance.currentMeetingId.value);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()),
        (r) async {
      agoraToken.value = r['data']['token'];

      await navigateToCallView();
    });
  }

  Future<dynamic> createDailyRoom() async {
    var data = <String, dynamic>{};
    final chatController = ChatController.instance;
    DateTime dateMeetingEndAt =
        DateTime.parse(DashboardController.instance.currentMeetingET.value)
            .toLocal();
    DateTime now = DateTime.now();

    // Duration between now and meeting end
    int timeLeft = dateMeetingEndAt.difference(now).inSeconds;

    // Never allow negative seconds
    timeLeft = timeLeft.clamp(0, double.infinity).toInt();

    Either either = await repo.createDailyRoom(
        channel: chatController.chatChannel.value,
        timeLeft: 15,
        chatId: chatController.chatId!.value);

    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()), (r) {
      if (r != null) {
        data = Map<String, dynamic>.from(r);
      }
    });

    DailyRoom dailyRoom = DailyRoom.fromJson(data);

    return dailyRoom;
  }

  Future getDailyToken() async {
    var endTimeInString = DashboardController.instance.currentMeetingET.value;
    DateTime dateMeetingEndAt = DateTime.parse(endTimeInString).toLocal();
    // Duration between now and meeting end
    int timeLeft = dateMeetingEndAt.difference(now).inSeconds;
    print("MEETING END DAT: $dateMeetingEndAt");
    // Never allow negative seconds
    timeLeft = timeLeft.clamp(0, double.infinity).toInt();
    print("TIME LEFT: $timeLeft");
    final chatController = ChatController.instance;
    var token = "";
    var room = chatController.chatChannel.value;

    Either either = await repo.generateDailyToken(
        room: room,
        timeLeft: 15,
        userType: consultant);

    either.fold(
          (l) => CustomSnackBar.errorSnackBar(l.message.toString()),
          (r) {
        var data = Map<String, dynamic>.from(r);
        token = data['token'];
      },
    );

    return token;
  }

  Future navigateToCallView() async {
    if (kIsWeb) {
      DailyRoom dailyRoom = await createDailyRoom();
      print("Daily room: ${dailyRoom.toJson()}");
      String token = await getDailyToken();
      print("Daily token: $token");

      Get.to(WebVideoCallView(dailyRoom: dailyRoom, token: token));

    } else {
      Get.to(const VideoCallView(
        isLocal: true,
      ));
    }
  }
}
