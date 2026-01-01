import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/chat/data/models/room_model.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/video_call_view.dart';
import 'package:tl_consultant/features/chat/presentation/screens/web_video_call_view.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/main.dart';

class VideoCallController extends GetxController {
  static VideoCallController get instance => Get.find<VideoCallController>();

  ChatRepoImpl repo = ChatRepoImpl();

  final now = DateTimeExtension.now;
  RxMap roomData = {}.obs;

  Future<dynamic> createDailyRoom() async {
    final meetingsController = MeetingsController.instance;
    final chatController = ChatController.instance;
    var room = chatController.chatChannel.value;

    var data = <String, dynamic>{};

    // Duration between now and meeting end
    int timeLeft = meetingsController.currentMeeting.value!.endAt
        .difference(now)
        .inSeconds;
    const int maxSeconds = 35 * 60; // 2100 seconds
    // Never allow negative seconds
    timeLeft = timeLeft.clamp(0, maxSeconds).toInt();

    Either either = await repo.createDailyRoom(
        channel: room, timeLeft: 120, chatId: chatController.chatId!.value);

    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()), (r) {
      if (r != null) {
        data = Map<String, dynamic>.from(r);
      }
    });

    DailyRoom dailyRoom = DailyRoom.fromJson(data);

    return dailyRoom;
  }

  Future getDailyToken() async {
    final meetingsController = MeetingsController.instance;
    final chatController = ChatController.instance;
    var room = chatController.chatChannel.value;

    var token = "";

    // Duration between now and meeting end
    int timeLeft = meetingsController.currentMeeting.value!.endAt
        .difference(now)
        .inSeconds;
    const int maxSeconds = 35 * 60; // 2100 seconds
    // Never allow negative seconds
    timeLeft = timeLeft.clamp(0, maxSeconds).toInt();

    Either either = await repo.generateDailyToken(
        room: room, timeLeft: 120, userType: consultant);

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
    DailyRoom dailyRoom = await createDailyRoom();
    String token = await getDailyToken();

    Get.toNamed(
      Routes.WEB_VIDEO_CALL,
      parameters: {
        'room': dailyRoom.room ?? '',
        'roomUrl': dailyRoom.roomUrl ?? '',
        'expiresAt': '${dailyRoom.expiresAt ?? 0}',
        'token': token,
      },
    );
  }

  bool canJoinVideoCall({
    required int currentMeetingId,
    int maxDurationSeconds = 15 * 60,
  }) {
    final data = storage.read('last_complete_video_call');
    if (data == null || data is! Map) return true;

    final storedMeetingId = data['meeting_id'];
    final storedDuration = data['duration'];

    if (storedMeetingId != currentMeetingId) return true;

    if (storedDuration is int && storedDuration < maxDurationSeconds) {
      return true; // still allowed
    }

    return false;
  }
}
