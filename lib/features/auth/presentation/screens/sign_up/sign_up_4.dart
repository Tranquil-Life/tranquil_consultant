import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/main.dart';

class VideoRecorderScreen extends StatefulWidget {
  const VideoRecorderScreen({Key? key});

  @override
  _VideoRecorderScreenState createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  late CameraController controller;
  late bool isRecording;
  Duration recordingDuration = Duration.zero; // Initialize with a default value
  final int maxRecordingSeconds = 60;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    isRecording = false;
    stopwatch = Stopwatch();
    controller = CameraController(
        cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    stopwatch.stop();
    super.dispose();
  }

  void startRecording() async {
    try {
      await controller.startVideoRecording();
      stopwatch.start();
      isRecording = true;
      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          recordingDuration = stopwatch.elapsed;
          if (recordingDuration.inSeconds >= maxRecordingSeconds) {
            stopRecording();
          }
        });
      });
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  void stopRecording() async {
    if (controller.value.isRecordingVideo) {
      await controller.stopVideoRecording();
      stopwatch.stop();
      stopwatch.reset();
      isRecording = false;
      recordingDuration = Duration.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Video Record",
        hideBackButton: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.6,
                  child: CameraPreview(controller),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/icons/play.png'),
                        onPressed: () {
                          // Add logic to handle play/pause
                        },
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: isRecording
                                ? Image.asset('assets/images/icons/stop.png')
                                : Image.asset('assets/images/icons/record.png'),
                            onPressed: () {
                              if (isRecording) {
                                stopRecording();
                              } else {
                                startRecording();
                              }
                            },
                          ),
                          if (isRecording)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorPalette.green,
                                  width: 4,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${recordingDuration.inSeconds}/${maxRecordingSeconds}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
