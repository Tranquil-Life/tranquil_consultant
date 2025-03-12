import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with SingleTickerProviderStateMixin {
  final videoRecordingController = Get.put(VideoRecordingController());
  late VideoPlayerController _videoPlayerController;
  late AnimationController animationController;
  late Animation<double> _animation;
  Future<void>? _videoPlayerFuture;
  double _currentPosition = 0.0;

  @override
  void initState() {
    initAnimation();
    setupVideoPlayer();

    super.initState();
  }

  @override
  void dispose() {
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

  Future initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
    if (widget.videoUrl.isNotEmpty) {
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                  SvgElements.svgVideoPlayOutlineIcon),
              SizedBox(width: 12),
              Text("Video recording"),
            ],
          ),
          Divider(color: ColorPalette.grey[900],),

          SizedBox(
              height: 320,
              width: displayWidth(context),
              child: FutureBuilder(
                future: _videoPlayerFuture,
                builder: (context, state) {
                  if (state.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  } else {
                    return VideoPlayer(_videoPlayerController);
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
                          //shareFile();
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

                  SizedBox(height: 10),

                  // CustomButton(
                  //     onPressed: (){
                  //       videoRecordingController.resetUploadVars();
                  //
                  //       Get.to(() => const VideoRecordingPage());
                  //     },
                  //     text: "Retake video",
                  //     textColor: ColorPalette.green,
                  //     showBorder: true,
                  //     bgColor: ColorPalette.white),
                  // SizedBox(height: 20),

                ],
              )),


        ],
      ),
    );
  }
}
