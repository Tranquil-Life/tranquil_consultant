import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class WebVideoRecordingPage extends StatefulWidget {
  const WebVideoRecordingPage({super.key});

  @override
  State<WebVideoRecordingPage> createState() => _WebVideoRecordingPageState();
}

class _WebVideoRecordingPageState extends State<WebVideoRecordingPage> {
  final authController = AuthController.instance;

  late html.EventListener _listener;
  late html.IFrameElement _iframe;
  late String _viewType;
  late String username;
  late String pageUrl;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map?;
    username = (args?['username'] ?? 'anonymous').toString();
    pageUrl = MediaEndpoints.webVideoRecordUrl(username: username);

    _viewType = 'web-video-record-${DateTime.now().millisecondsSinceEpoch}';

    _iframe = html.IFrameElement()
      ..src = pageUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'camera; microphone; autoplay';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _iframe,
    );

    _listener = (event) {
      if (event is html.MessageEvent) {
        final data = event.data;

        if (data is Map && data['type'] == 'SIGNING_COMPLETE') {
          final videoUrl = data['videoUrl'];
          final photoUrl = data['photoUrl'];

          print("Received from web:");
          print("videoUrl: $videoUrl");
          print("photoUrl: $photoUrl");

          if (videoUrl != null && videoUrl.toString().isNotEmpty && photoUrl != null && photoUrl.toString().isNotEmpty) {
            // authController.introVideo.value = videoUrl.toString();
            // authController.profilePic.value = photoUrl.toString();

            debugPrint("Video URL: ${authController.introVideo.value}");
            debugPrint("Photo URL: ${authController.profilePic.value}");

            // Get.back(result: {
            //   "videoUrl": videoUrl.toString(),
            //   "photoUrl": photoUrl?.toString() ?? "",
            // });
          }
        }
      }
    };

    html.window.addEventListener('message', _listener);
  }

  @override
  void dispose() {
    html.window.removeEventListener('message', _listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Video'),
      ),
      body: HtmlElementView(viewType: _viewType),
    );
  }
}
