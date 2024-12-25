import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:video_player/video_player.dart';

class VideoRecordingPage extends StatefulWidget {
  const VideoRecordingPage({super.key});

  @override
  State<VideoRecordingPage> createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends State<VideoRecordingPage>
    with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  late CameraController _cameraController;
  late VideoPlayerController _videoPlayerController;
  late AnimationController animationController;
  late Animation<double> _animation;
  Future<void>? _videoPlayerFuture;

  XFile video = XFile("");
  String cleanVideoPath = "";

  bool _isLoading = true;
  bool isRecording = false;
  bool inVideoPlayerState = false;
  double _currentPosition = 0.0;

  @override
  void initState() {

    profileController.uploadProgress.value = 0.0;
    initAnimation();
    initCamera();

    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    animationController.dispose();
    _videoPlayerController.dispose();

    super.dispose();
  }

  initAnimation() {
    // Initialize AnimationController for 1 minute (60 seconds)
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1), // 1 minute duration
    );

    // Create a Tween to animate progress from 0.0 to 1.0
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
          ..addListener(() {
            setState(() {}); // Update UI as animation progresses
          });

    animationController.forward(); // Start the animation
  }

  /// Video Recording related functions
  ///
  initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController =
        CameraController(front, ResolutionPreset.max, enableAudio: true);
    await _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    setState(() => _isLoading = false);
  }

  Future<void> startRecording() async {
    if (!isRecording) {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => isRecording = true);
      inVideoPlayerState = false;

      animationController.reset();
      animationController.forward();
    }

    await Future.delayed(const Duration(minutes: 1)); // Simulate task duration

    if (isRecording) {
      video = await _cameraController.stopVideoRecording(); // Returns an XFile
      File videoFile = File(video.path);
      setState(() => isRecording = false);

      animationController.reset();
      inVideoPlayerState = true;

      setupVideoPlayer();

      print('Video saved at: ${videoFile.path}');
    }
  }

  Future stopRecording() async {
    if (isRecording) {
      video = await _cameraController.stopVideoRecording(); // Returns an XFile
      File videoFile = File(video.path); // Convert XFile to File

      setState(() => isRecording = false);

      animationController.reset();
      inVideoPlayerState = true;

      setupVideoPlayer();

      print('Video saved at: ${videoFile.path}');
    }
  }

  /// Video Player related functions
  ///
  Future initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(video.path))
      ..addListener(() {
        setState(() {
          _currentPosition =
              _videoPlayerController.value.position.inMilliseconds.toDouble();
        });
      });
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  void setupVideoPlayer() {
    if (video.path.isNotEmpty) {
      _videoPlayerFuture = initVideoPlayer();
    }
  }

  Future pauseVideoPlayer() async {
    _videoPlayerController.pause();
  }

  Future playVideoPlayer() async {
    _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalette.scaffoldColor,
        body: _isLoading
            ? Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      if (inVideoPlayerState)
                        Column(
                          children: [
                            SizedBox(
                                height: 500,
                                width: displayWidth(context),
                                child: FutureBuilder(
                                  future: _videoPlayerFuture,
                                  builder: (context, state) {
                                    if (state.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return VideoPlayer(
                                          _videoPlayerController);
                                    }
                                  },
                                )),
                            Slider(
                              value: _currentPosition,
                              max: _videoPlayerController
                                  .value.duration.inMilliseconds
                                  .toDouble(),
                              min: 0.0,
                              onChanged: (value) {
                                setState(() {
                                  _currentPosition = value;
                                });
                                _videoPlayerController.seekTo(
                                    Duration(milliseconds: value.toInt()));
                              },
                              activeColor: Colors.green,
                              inactiveColor: Colors.green.shade100,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(formatDuration(_currentPosition)),
                                        Text(formatDuration(
                                            _videoPlayerController
                                                .value.duration.inMilliseconds
                                                .toDouble()))
                                      ],
                                    ),

                                    SizedBox(height: 24),
                                    // Playback Controls
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          SvgElements.svgDownloadIcon,
                                          height: 30,
                                          width: 30,
                                        ),
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: ColorPalette.green.shade100,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                              child: GestureDetector(
                                            onTap: () => setState(() {
                                              if (_videoPlayerController
                                                  .value.isPlaying) {
                                                _videoPlayerController.pause();
                                              } else {
                                                _videoPlayerController.play();
                                              }
                                            }),
                                            child: Container(
                                              padding: EdgeInsets.all(14),
                                              child: _videoPlayerController
                                                      .value.isPlaying
                                                  ? SvgPicture.asset(
                                                      SvgElements.svgPauseIcon)
                                                  : SvgPicture.asset(
                                                      SvgElements.svgPlayIcon),
                                            ),
                                          )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            shareFile(File(video.path));
                                          },
                                          child: SvgPicture.asset(
                                            SvgElements.svgShareIcon,
                                            color: ColorPalette.gray[800],
                                            height: 24,
                                            width: 24,
                                          ),
                                        )
                                      ],
                                    ),

                                    SizedBox(height: 40),

                                    CustomButton(
                                        onPressed: () {

                                        },
                                        text: "Retake video",
                                        textColor: ColorPalette.green,
                                        showBorder: true,
                                        bgColor: ColorPalette.white),
                                    SizedBox(height: 20),

                                    Obx(() => CustomButton(
                                        onPressed: (uploadTextState() ==
                                                    successfulUploadMsg ||
                                                uploadTextState() ==
                                                    compressingVideoMsg ||
                                                uploadTextState().contains(
                                                    uploadingVideoMsg))
                                            ? null
                                            : () async {
                                                print("upload: recording");

                                                await profileController
                                                    .uploadFile(
                                                        File(video.path),
                                                        videoIntro);
                                              },
                                        textColor: uploadTextState() ==
                                            successfulUploadMsg ||
                                            uploadTextState() ==
                                                compressingVideoMsg ||
                                            uploadTextState().contains(
                                                uploadingVideoMsg) ? ColorPalette.green : ColorPalette.white,
                                        text: uploadTextState()))
                                  ],
                                )),
                          ],
                        )
                      else
                        CameraPreview(_cameraController),
                      SizedBox(height: 24),
                      if (!inVideoPlayerState)
                        //The recorder controller icons
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: ColorPalette.green),
                                      borderRadius: BorderRadius.circular(100)),
                                  child:
                                      SvgPicture.asset(SvgElements.svgPlayIcon),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    startRecording();
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    // Align both widgets perfectly at the center
                                    children: [
                                      // Base Container - the circle with a border
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 6,
                                              color: Colors.green.shade200),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: ColorPalette.green,
                                            ),
                                            height: 32,
                                            width: 32,
                                          ),
                                        ),
                                      ),

                                      // Circular Progress Indicator
                                      if (isRecording)
                                        SizedBox(
                                          height:
                                              54, // Match the container size
                                          width: 54,
                                          child: CircularProgressIndicator(
                                            value: _animation.value,
                                            strokeWidth: 4,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.green),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => stopRecording(),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: ColorPalette.green),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: SvgPicture.asset(
                                        SvgElements.svgStopIcon),
                                  ),
                                )
                              ],
                            ))
                    ],
                  ),
                  Positioned(
                      top: 40,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white),
                                child: Icon(Icons.close, size: 18),
                              )),
                        ],
                      )),
                ],
              ));
  }

  String uploadTextState() {
    if (profileController.compressing.value) {
      return compressingVideoMsg;
    } else if ((profileController.uploadProgress.value > 0.0 &&
        profileController.uploadProgress.value < 100.0) || profileController.uploading.value) {
      return "$uploadingVideoMsg: ${profileController.uploadProgress.value.toStringAsFixed(2)}%";
    } else if (profileController.uploadProgress.value.toInt() == 100) {
      return successfulUploadMsg;
    } else {
      return "Save video and upload";
    }
  }
}
