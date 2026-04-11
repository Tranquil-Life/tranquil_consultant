import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';

class WebVideoRecordingPage extends StatefulWidget {
  const WebVideoRecordingPage({super.key});

  @override
  State<WebVideoRecordingPage> createState() => _WebVideoRecordingPageState();
}

class _WebVideoRecordingPageState extends State<WebVideoRecordingPage> {
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

        if (data is Map && data['type'] == 'VIDEO_UPLOAD_SUCCESS') {
          final videoUrl = data['videoUrl'];

          if (videoUrl != null && videoUrl.toString().isNotEmpty) {
            Get.back(result: videoUrl.toString());
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
