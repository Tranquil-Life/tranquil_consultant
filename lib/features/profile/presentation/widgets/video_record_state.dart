import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/data/store.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/media/presentation/controllers/media_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

class VideoRecordState extends StatefulWidget {
  const VideoRecordState({super.key, required this.profileController, required this.mediaController});

  final ProfileController profileController;
  final MediaController mediaController;


  @override
  State<VideoRecordState> createState() => _VideoRecordStateState();
}

class _VideoRecordStateState extends State<VideoRecordState> {
  @override
  void initState() {
    widget.mediaController.initializeVideoPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: displayWidth(context),
      decoration: BoxDecoration(
        color: ColorPalette.green.shade300,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1, color: ColorPalette.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            width: 1, color: Color(0xFF62B778))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                          SvgElements.svgVideoPlayIcon),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Play video",
                        style: TextStyle(
                          color: ColorPalette.grey.shade400,
                          fontSize: AppFonts.baseSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Obx(()=>Text("${widget.profileController.introVideoDuration.value} secs",
                        style: TextStyle(
                          color: ColorPalette.grey.shade300,
                          fontSize: AppFonts.defaultSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),)


                    ],
                  ),
                ),
              ],
            ),
          ),

          // widget.profileController.introVideo.value!.isNotEmpty ?
          // GestureDetector(
          //     onTap: () {
          //       _showDeleteVideoDialog(context, widget.videoRecordingController, widget.profileController);
          //     },
          //     child: SvgPicture.asset("assets/images/icons/trash.svg")) : SizedBox.shrink()
        ],
      ),
    );
  }
}

void _showDeleteVideoDialog(BuildContext context, MediaController mediaController, ProfileController profileController) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: ColorPalette.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Delete video file?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.black),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFFDDDDD)),
                  child: SvgPicture.asset("assets/images/icons/trash.svg")),
              SizedBox(
                height: 20,
              ),
              Text(
                "You need to have a video recording for your clients in your profile",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.grey.shade800),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 1,
                              color: ColorPalette.green.shade500,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Close",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.green.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onPressed: () async{
                          // await mediaController.deleteFileFromUrl(profileController.introVideo.value!);
                          //
                          // userDataStore.user['video_intro'] = "";
                          // await getStore.set('user', userDataStore.user);
                          // profileController.introVideo.value = "";
                          //
                          // Get.back();
                        },
                        text: "Delete File",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

