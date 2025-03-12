import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/picture_upload_option.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/video_record_option.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/media/presentation/screens/video_record_page.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class IntroduceYourselfPage extends StatefulWidget {
  const IntroduceYourselfPage({super.key});

  @override
  State<IntroduceYourselfPage> createState() => _IntroduceYourselfPageState();
}

class _IntroduceYourselfPageState extends State<IntroduceYourselfPage> {
  final authController = Get.put(AuthController());
  final videoRecordingController = Get.put(VideoRecordingController());

  var selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create your account',
        centerTitle: false,
        backgroundColor: ColorPalette.scaffoldColor,
      ),
      backgroundColor: ColorPalette.scaffoldColor,
      body: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Introduce yourself",
                  style: TextStyle(
                    color: ColorPalette.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Complete your profile by taking the following steps",
                  style: TextStyle(
                      fontSize: AppFonts.defaultSize,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.grey.shade500),
                ),
                SizedBox(height: 40),
                VideoRecordOption(
                  authController: authController,
                  onTap: () async{
                    setState(() {
                      selectedOption = video;
                    });

                    videoRecordingController.resetUploadVars();

                    await Future.delayed(Duration(seconds: 1));
                    Get.to(() => const VideoRecordingPage());

                  },
                  selected: selectedOption == video ? true : false,
                ),
                SizedBox(height: 24),
                PictureUploadOption(
                  authController: authController,
                  selected: selectedOption == picture ? true : false,
                  onTap: () async{
                    setState(() {
                      selectedOption = picture;
                    });

                    await Future.delayed(Duration(seconds: 1));
                    File? file = await MediaService.selectImage(ImageSource.gallery);
                    // await profileController.uploadVideo(File(video.path));
                    await videoRecordingController.uploadFile(file!, profileImage, authController);

                  },
                ),
                SizedBox(
                  height: displayHeight(context) / 10,
                ),
                Obx(()=>CustomButton(
                    onPressed: (
                        authController.profilePic.value.isEmpty)
                        ? null
                        : () {
                      authController.signUp();
                    },
                    text: "Complete sign up")),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    //..
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: 'I have an account. ',
                        children: const [
                          TextSpan(
                            text: 'Sign me in...',
                            style: TextStyle(
                                color: ColorPalette.green,
                                fontFamily: AppFonts.josefinSansRegular),
                          ),
                        ],
                        style: TextStyle(
                            color: ColorPalette.grey.shade300,
                            fontFamily: AppFonts.josefinSansRegular),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
