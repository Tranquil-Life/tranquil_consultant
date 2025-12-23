import 'dart:ui_web' as ui; // Use dart:ui for older Flutter versions
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
import 'package:tl_consultant/features/chat/data/models/room_model.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class WebVideoCallView extends StatefulWidget {
  const WebVideoCallView({super.key, this.dailyRoom, this.token});

  final DailyRoom? dailyRoom;
  final String? token;

  @override
  State<WebVideoCallView> createState() => _WebVideoCallViewState();
}

class _WebVideoCallViewState extends State<WebVideoCallView> {
  late final String viewID;
  late final String callUrl;

  @override
  void initState() {
    super.initState();

    viewID = "video-call-${widget.dailyRoom?.room}-${DateTime.now().millisecondsSinceEpoch}";

    callUrl = ChatEndPoints.webVideoCallUrl(
      room: widget.dailyRoom!.room,
      token: widget.token!,
    );

    ui.platformViewRegistry.registerViewFactory(
      viewID,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: HtmlElementView(viewType: viewID),
    );
  }
}