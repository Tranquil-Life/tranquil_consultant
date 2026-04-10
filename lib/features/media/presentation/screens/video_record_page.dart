import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/media_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:video_player/video_player.dart';

class VideoRecordingPage extends StatefulWidget {
  const VideoRecordingPage({super.key});

  @override
  State<VideoRecordingPage> createState() => _VideoRecordingPageState();
}

class _VideoRecordingPageState extends State<VideoRecordingPage>
    with SingleTickerProviderStateMixin {
  final mediaController = MediaController.instance;
  final profileController = ProfileController.instance;
  final authController = AuthController.instance;

  late CameraController _cameraController;
  VideoPlayerController? _videoPlayerController;
  late AnimationController animationController;
  late Animation<double> _animation;
  Future<void>? _videoPlayerFuture;

  XFile video = XFile("");
  String cleanVideoPath = "";

  bool _isLoading = true;
  bool isRecording = false;
  bool inVideoPlayerState = false;
  double _currentPosition = 0.0;

  String previousRoute = '';

  bool _isStoppingRecording = false;
  bool _isMobileWebDevice = false;
  bool _didInitPage = false;
  Timer? _autoStopTimer;
  bool _didFinishRecording = false;

  Duration get recordingDuration =>
      _isMobileWebDevice
          ? const Duration(seconds: 20)
          : const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    previousRoute = Get.previousRoute;
    mediaController.uploadProgress.value = 0.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didInitPage) {
      _isMobileWebDevice = isMobileWeb(context);
      initAnimation();
      initCamera();
      _didInitPage = true;
    }
  }

  @override
  void dispose() {
    _autoStopTimer?.cancel();
    _cameraController.dispose();
    animationController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void initAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: recordingDuration,
    );

    _animation =
    Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      debugPrint("No cameras found");
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    CameraController? tempController;
    ResolutionPreset resolution = _isMobileWebDevice
        ? ResolutionPreset.low
        : ResolutionPreset.max;

    try {
      final selectedCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      tempController = CameraController(
        selectedCamera,
        resolution,
        enableAudio: true,
      );
    } catch (e) {
      tempController = CameraController(
        cameras.first,
        resolution,
        enableAudio: true,
      );
    }

    _cameraController = tempController;

    try {
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Camera init error: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> startRecording() async {
    if (isRecording || _isStoppingRecording) return;

    _didFinishRecording = false;

    await _cameraController.prepareForVideoRecording();
    await _cameraController.startVideoRecording();

    if (!mounted) return;

    setState(() {
      isRecording = true;
      inVideoPlayerState = false;
      _videoPlayerFuture = null;
      _currentPosition = 0.0;
    });

    animationController.duration = recordingDuration;
    animationController.reset();
    animationController.forward();

    _autoStopTimer?.cancel();
    _autoStopTimer = Timer(recordingDuration, () {
      stopRecording(); // same handler as stop button
    });
  }

  Future<void> stopRecording() async {
    if (!isRecording || _isStoppingRecording || _didFinishRecording) return;

    _isStoppingRecording = true;
    _didFinishRecording = true;
    _autoStopTimer?.cancel();

    try {
      final recordedVideo = await _cameraController.stopVideoRecording();

      if (!mounted) return;

      video = recordedVideo;

      setState(() {
        isRecording = false;
        inVideoPlayerState = true;
        _videoPlayerFuture = initVideoPlayer();
      });

      animationController.stop();
      animationController.reset();
    } catch (e) {
      debugPrint("stopRecording error: $e");

      if (!mounted) return;

      setState(() {
        isRecording = false;
      });

      animationController.stop();
      animationController.reset();
    } finally {
      _isStoppingRecording = false;
    }
  }

  Future<void> initVideoPlayer() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }

    if (kIsWeb) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(video.path),
      );
    } else {
      _videoPlayerController = VideoPlayerController.file(File(video.path));
    }

    _videoPlayerController!.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition =
              _videoPlayerController!.value.position.inMilliseconds.toDouble();
        });
      }
    });

    await _videoPlayerController!.initialize();
    await _videoPlayerController!.setLooping(true);
    await _videoPlayerController!.play();
  }

  void setupVideoPlayer() {
    if (video.path.isNotEmpty) {
      _videoPlayerFuture = initVideoPlayer();
    }
  }

  Future pauseVideoPlayer() async {
    _videoPlayerController?.pause();
  }

  Future playVideoPlayer() async {
    _videoPlayerController?.play();
  }

  String uploadTextState() {
    if (mediaController.compressing.value) {
      return compressingVideoMsg;
    } else if ((mediaController.uploadProgress.value > 0.0 &&
        mediaController.uploadProgress.value < 100.0) ||
        mediaController.uploading.value) {
      return "$uploadingVideoMsg: ${mediaController.uploadProgress.value.toStringAsFixed(2)}%";
    } else if (mediaController.uploadProgress.value.toInt() == 100) {
      return successfulUploadMsg;
    } else {
      return "Save video and upload";
    }
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
            SingleChildScrollView(
              child: Column(
                children: [

                  if (inVideoPlayerState)
                    FutureBuilder(
                      future: _videoPlayerFuture,
                      builder: (context, state) {
                        // Check 1: Is the future even created yet?
                        if (_videoPlayerFuture == null) {
                          return SizedBox(
                            height: 500,
                            width: displayWidth(context),
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.green)),
                          );
                        }

                        // Check 2: Is it still loading or did it error?
                        if (state.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 500,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.green)),
                          );
                        } else if (state.hasError) {
                          return SizedBox(
                            height: 500,
                            child: Center(
                                child: Text("Error: ${state.error}")),
                          );
                        }

                        // Check 3: Is the controller actually ready?
                        if (_videoPlayerController == null ||
                            !_videoPlayerController!
                                .value.isInitialized) {
                          return const SizedBox(
                            height: 500,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.red)),
                          );
                        }

                        // SUCCESS: Show the player and controls
                        return Column(
                          children: [
                            SizedBox(
                              height: 500,
                              width: displayWidth(context),
                              child: VideoPlayer(_videoPlayerController!),
                            ),
                            Slider(
                              value: _currentPosition,
                              max: _videoPlayerController!
                                  .value.duration.inMilliseconds
                                  .toDouble(),
                              min: 0.0,
                              onChanged: (value) {
                                setState(() {
                                  _currentPosition = value;
                                });
                                _videoPlayerController?.seekTo(Duration(
                                    milliseconds: value.toInt()));
                              },
                              activeColor: Colors.green,
                              inactiveColor: Colors.green.shade100,
                            ),

                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatDuration(
                                          _currentPosition)),
                                      Text(formatDuration(
                                          _videoPlayerController!.value
                                              .duration.inMilliseconds
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
                                          color:
                                          ColorPalette.green.shade100,
                                          borderRadius:
                                          BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () => setState(() {
                                              if (_videoPlayerController!
                                                  .value.isPlaying) {
                                                _videoPlayerController
                                                    ?.pause();
                                              } else {
                                                _videoPlayerController
                                                    ?.play();
                                              }
                                            }),
                                            child: Container(
                                              padding: EdgeInsets.all(14),
                                              child: _videoPlayerController!
                                                  .value.isPlaying
                                                  ? SvgPicture.asset(
                                                  SvgElements
                                                      .svgPauseIcon)
                                                  : SvgPicture.asset(
                                                  SvgElements
                                                      .svgPlayIcon),
                                            ),
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          shareFile(
                                              fileToShare:
                                              File(video.path));
                                        },
                                        child: SvgPicture.asset(
                                          SvgElements.svgShareIcon,
                                          color: ColorPalette.grey[800],
                                          height: 24,
                                          width: 24,
                                        ),
                                      )
                                    ],
                                  ),

                                  SizedBox(height: 40),

                                  CustomButton(
                                      onPressed: () async {
                                        Get.back();

                                        await Future.delayed(
                                            Duration(seconds: 1));

                                        mediaController.resetUploadVars();

                                        Get.to(() =>
                                        const VideoRecordingPage());
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
                                        if (previousRoute ==
                                            Routes
                                                .INTRODUCE_YOURSELF) {
                                          await mediaController
                                              .uploadFile(
                                              video,
                                              videoIntro,
                                              authController);
                                        } else {
                                          await mediaController
                                              .uploadFile(
                                              video,
                                              videoIntro,
                                              profileController);
                                        }
                                      },
                                      textColor: uploadTextState() ==
                                          successfulUploadMsg ||
                                          uploadTextState() ==
                                              compressingVideoMsg ||
                                          uploadTextState().contains(
                                              uploadingVideoMsg)
                                          ? ColorPalette.green
                                          : ColorPalette.white,
                                      text: uploadTextState()))
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    )
                  else
                    if(isLargeScreen(context))
                      Container(
                        height: 600,
                        width: displayWidth(context),
                        child: CameraPreview(_cameraController),
                      )
                    else
                      Container(
                        height: 300,
                        width: displayWidth(context),
                        child: CameraPreview(_cameraController),
                      ),
                  // CameraPreview(_cameraController),
                  SizedBox(height: 24),
                  if (!inVideoPlayerState)
                  //The recorder controller icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
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
                        ),

                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => stopRecording(),
                              child: Wrap(
                                children: [
                                  Container(
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
                                  )
                                ],
                              ),
                            ))
                      ],
                    )
                ],
              ),
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
}
