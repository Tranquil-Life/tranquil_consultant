import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'dart:io';
import 'package:flutter_camera/flutter_camera.dart';

class VideoRecorderScreen extends StatefulWidget {
  const VideoRecorderScreen({super.key});

  @override
  State<VideoRecorderScreen> createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return FlutterCamera(
      color: Colors.amber,
      onImageCaptured: (value) {},
      onVideoRecorded: (value) {},
    );
  }
}

class AudioRecordScreen extends StatefulWidget {
  const AudioRecordScreen({super.key});

  @override
  State<AudioRecordScreen> createState() => _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "Audio recording",
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterCamera(
      color: Colors.amber,
      onImageCaptured: (value) {},
      onVideoRecorded: (value) {},
    );
    // return Container();
  }
}
