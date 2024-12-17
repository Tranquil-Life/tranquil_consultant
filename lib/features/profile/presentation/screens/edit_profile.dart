import 'dart:io';

import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/broken_vertical_line.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/drop_down_menu.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/edit_profile_fields.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/qualification_fields.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.getMyLocationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.scaffoldColor,
      appBar: CustomAppBar(
        title: "Edit Profile",
        centerTitle: false,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 60),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                const EditProfileHead(),
                const SizedBox(
                  height: 50,
                ),
                EditProfileFields(profileController: profileController),

                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showDiscardChangesDialog(context);
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
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.green.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          profileController.updateUser();
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                              color: Colors.white, fontSize: AppFonts.defaultSize),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _showDiscardChangesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: ColorPalette.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Discard changes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.black),
              ),
              SizedBox(
                height: 20,
              ),
              SvgPicture.asset("assets/images/icons/container.svg"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Do you want to exit this page without saving your changes?",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.gray.shade800),
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          // Pop EditProfileScreen and go back to the previous screen
                        },
                        text: "Cancel",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}

class EditProfileHead extends StatefulWidget {
   const EditProfileHead({super.key});

  @override
  State<EditProfileHead> createState() => _EditProfileHeadState();
}

class _EditProfileHeadState extends State<EditProfileHead> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage("assets/images/profile/therapist.png"),
              radius: 60,
            ),
            // UserAvatar(),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              width: 200,
              child: CustomButton(
                onPressed: () async{
                  File? file = await MediaService.selectImage(ImageSource.camera);
                  // await profileController.uploadVideo(File(video.path));
                  await profileController.uploadFile(file!, profileImage);
                },
                child: const Text(
                  'Edit profile picture',
                  style: TextStyle(
                      color: ColorPalette.white, fontSize: AppFonts.baseSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
