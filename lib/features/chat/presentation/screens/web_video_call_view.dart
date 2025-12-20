import 'dart:ui_web' as ui; // Use dart:ui for older Flutter versions
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/agora_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class WebVideoCallView extends StatefulWidget {
  const WebVideoCallView({super.key});

  @override
  State<WebVideoCallView> createState() => _WebVideoCallViewState();
}

class _WebVideoCallViewState extends State<WebVideoCallView> {
  final agoraController = AgoraController.instance;
  final chatController = ChatController.instance;

  final String viewID = "agora-video-call";


  @override
  void initState() {
    super.initState();

    // Construct your URL with the parameters
    final String callUrl = ChatEndPoints.webVideoCallUrl(
      room: "c6uDfgcc8EgDsahJV6dt",
      //TODO: The room should be the same as the pusher channel and should be created from the backend
      //not hard-coded
    );


    var data = {
      "appId": AppConfig.agoraAppId,
      "channel": chatController.myChannel.channelName,
      "token": agoraController.agoraToken.value,
      "uid": userDataStore.user['id']
    };

    print(data);

    // Register the IFrame element
    ui.platformViewRegistry.registerViewFactory(
      viewID,
          (int viewId) => html.IFrameElement()
        ..src = callUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = "camera; microphone; autoplay", // CRITICAL for video calls
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Call")),
      body: HtmlElementView(viewType: viewID),
    );
  }
}