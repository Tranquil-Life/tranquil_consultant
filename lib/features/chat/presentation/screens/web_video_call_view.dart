import 'dart:async';
import 'dart:ui_web' as ui; // Use dart:ui for older Flutter versions
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/global/app_bar_button.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/chat/data/models/room_model.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class WebVideoCallView extends StatefulWidget {
  const WebVideoCallView(
      {super.key, required this.dailyRoom, required this.token});

  final DailyRoom dailyRoom;
  final String token;

  @override
  State<WebVideoCallView> createState() => _WebVideoCallViewState();
}

class _WebVideoCallViewState extends State<WebVideoCallView> {
  final meetingController = MeetingsController.instance;

  Timer? _timer;
  late final String viewType;
  late final String callUrl;

  ChatRepoImpl chatRepo = ChatRepoImpl();

  int secondsLeft = 0;

  void getSecondsLeft() {
    final diff = DateTime.fromMillisecondsSinceEpoch(
            widget.dailyRoom.expiresAt * 1000,
            isUtc: true)
        .toLocal()
        .difference(DateTime.now())
        .inSeconds;

    final maxSeconds = 35 * 60;

    final next = diff.clamp(0, maxSeconds);

    if (!mounted) return;
    setState(() => secondsLeft = next);

    if (next == 0) {
      _timer?.cancel();

      chatRepo.saveCompletedVideoCall(
        meetingId: meetingController.currentMeeting.value!.id,
        durationSeconds: maxSeconds,
      );

      if (mounted) _exitCall();
    }
  }

  void _exitCall() async{
    _timer?.cancel();

    // If there is a previous page, pop to it.
    // After browser reload, this will usually be false.
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Get.offAllNamed(Routes.DASHBOARD);

    once(MeetingsController.instance.currentMeeting, (m) {
      if (m != null) {
        DashboardController.instance.currentIndex.value = 2;
      }
    });
  }


  @override
  void initState() {
    super.initState();

    getSecondsLeft();

    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => getSecondsLeft());

    viewType = 'daily-iframe-${widget.dailyRoom.room}';
    callUrl = ChatEndPoints.webVideoCallUrl(
      room: widget.dailyRoom.room,
      token: widget.token,
    );

    // Register once (web only)
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = callUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow = 'camera; microphone; autoplay; fullscreen; display-capture';
        return iframe;
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // blocks browser back + system back
      onPopInvoked: (didPop) {
        // didPop will always be false because canPop=false
        // CustomSnackBar.errorSnackBar("Use the back button in the app.");
      },
      child: Scaffold(
        backgroundColor: ColorPalette.black,
        appBar: AppBar(
          backgroundColor: ColorPalette.black,
          leading: Padding(padding: EdgeInsets.all(8), child: AppBarButton(
            backgroundColor: ColorPalette.white,
            onPressed: _exitCall, // only allowed exit
            icon: Center(child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 19),),
          )),
          title: CustomText(text: "$secondsLeft", color: ColorPalette.white),
        ),
        body: HtmlElementView(viewType: viewType),
      ),
    );
  }
}
