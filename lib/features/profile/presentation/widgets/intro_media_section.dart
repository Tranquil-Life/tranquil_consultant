import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/media/presentation/screens/video_record_page.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/no_video_record_state.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/video_player.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/video_record_state.dart';

class IntroMediaSection extends StatelessWidget {
  const IntroMediaSection(
      {super.key,
      required this.profileController,
      required this.videoRecordingController});

  final ProfileController profileController;
  final VideoRecordingController videoRecordingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "INTRO MEDIA",
          style: TextStyle(
            fontSize: AppFonts.baseSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        profileController.introVideo.value!.isEmpty
            ? GestureDetector(
                child: NoVideoRecordState(),
                onTap: () {
                  Get.to(() => const VideoRecordingPage());
                },
              )
            : GestureDetector(
                onTap: () {
                  if (profileController.introVideo.value!.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: VideoPlayerWidget(
                                videoUrl: profileController.introVideo.value!),
                          );
                        });
                  }
                },
                child: VideoRecordState(
                    profileController: profileController,
                    videoRecordingController: videoRecordingController),
              ),
        TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {
              videoRecordingController.resetUploadVars();

              Get.to(() => const VideoRecordingPage());
            },
            child: Text(
              "Retake video recording",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  color: ColorPalette.green),
            )),

        //AUDIO RECORD
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   width: displayWidth(context),
        //   decoration: BoxDecoration(
        //     color: ColorPalette.green.shade300,
        //     borderRadius: BorderRadius.circular(8.0),
        //     border: Border.all(width: 1, color: ColorPalette.gray.shade100),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: Row(
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.only(right: 12),
        //               child: Container(
        //                 height: 40,
        //                 width: 40,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(8.0),
        //                     border:
        //                         Border.all(width: 1, color: Color(0xFF62B778))),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: SvgPicture.asset(
        //                       height: 24,
        //                       width: 24,
        //                       "assets/images/icons/musicnote.svg"),
        //                 ),
        //               ),
        //             ),
        //             Expanded(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     "Play Audio",
        //                     style: TextStyle(
        //                       color: ColorPalette.gray.shade400,
        //                       fontSize: AppFonts.baseSize,
        //                       fontWeight: FontWeight.w400,
        //                     ),
        //                   ),
        //                   Text(
        //                     "57 secs",
        //                     style: TextStyle(
        //                       color: ColorPalette.gray.shade300,
        //                       fontSize: AppFonts.defaultSize,
        //                       fontWeight: FontWeight.w400,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       GestureDetector(
        //           onTap: () {},
        //           child: SvgPicture.asset("assets/images/icons/trash.svg"))
        //     ],
        //   ),
        // ),
        // TextButton(
        //     style: TextButton.styleFrom(
        //       padding: EdgeInsets.zero,
        //       alignment: Alignment.centerLeft,
        //     ),
        //     onPressed: () {},
        //     child: Text(
        //       "Retake audio recording",
        //       style: TextStyle(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w400,
        //           decoration: TextDecoration.underline,
        //           color: ColorPalette.green),
        //     )),
      ],
    );
  }
}
