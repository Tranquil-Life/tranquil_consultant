import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/media_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/edit_profile_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final profileController = ProfileController.instance;
  final dashboardController = DashboardController.instance;
  final mediaController = MediaController.instance;

  final editProfileKey = GlobalKey();

  String pageTitle() {
    User user = UserModel.fromJson(userDataStore.user);
    // if (user.firstName.isEmpty ||
    //     user.bio.isEmpty ||
    //     user.specialties!.isEmpty ||
    //     user.videoIntroUrl!.isEmpty ||
    //     profileController.qualifications.isEmpty) {
    //   return "Complete your profile";
    // } else {
    //   return "Edit your profile";
    // }

    return "Complete your profile";
  }

  void checkVariables() {
    if (dashboardController.firstName.value.isEmpty ||
        dashboardController.lastName.value.isEmpty) {
      dashboardController.restoreUserInfo();
    }
  }

  @override
  void initState() {
    checkVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        key: editProfileKey,
        backgroundColor: ColorPalette.scaffoldColor,
        appBar: CustomAppBar(
          title: pageTitle(),
          centerTitle: false,
          fontFamily: AppFonts.josefinSansRegular,
          backgroundColor: Colors.white,
          onBackPressed: () {
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            } else {
              Get.offNamed(Routes.PROFILE); // fallback route
            }
          },
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
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

                  //Edit profile fields
                  EditProfileFields(
                    profileController: profileController,
                    mediaController: mediaController,
                  ),

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
                                color: ColorPalette.green,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ColorPalette.green,
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
                                color: Colors.white,
                                fontSize: AppFonts.defaultSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )),
      ),
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
  final profileController = ProfileController.instance;
  final mediaController = MediaController.instance;

  static const double _radius = 60;
  static const double _diameter = _radius * 2;

  @override
  Widget build(BuildContext context) {
    final url =
        "https://firebasestorage.googleapis.com/v0/b/tranquil-life-llc.appspot.com/o/profile_image%2F1_1768927695513.jpg?alt=media&token=e5f165b8-058d-4673-a467-c43dc6e2a95d";
    return Center(
      child: Column(
        children: [
          /*Container(
            width: _diameter,
            height: _diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPalette.grey[100],
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network("https://firebasestorage.googleapis.com/v0/b/tranquil-life-llc.appspot.com/o/profile_image%2F1_1768927695513.jpg?alt=media&token=e5f165b8-058d-4673-a467-c43dc6e2a95d"),
            // child: UserAvatar(size: _diameter, imageUrl: DashboardController.instance.profilePic.value,),
          ),*/
          Text(url),

          ClipOval(
            child: Image.network(
              url,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                debugPrint("Image load error: $error");
                return const Icon(
                  Icons.person,
                  size: 32,
                  color: Colors.white,
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 200,
            child: CustomButton(
              onPressed: () async {
                try {
                  if (kIsWeb) {
                    print(
                        "profile picture: ${DashboardController.instance.profilePic.value}");
                    // await profileController.updateProfilePicture();
                  } else {
                    final file =
                        await MediaService.selectImage(ImageSource.gallery);
                    if (file == null) return;

                    await mediaController.uploadFile(
                      file,
                      profileImage,
                      profileController,
                    );
                  }
                } catch (e, st) {
                  debugPrint("Update profile picture error: $e");
                  debugPrint("$st");
                }
              },
              child: const Text(
                'Edit profile picture',
                style: TextStyle(
                  color: ColorPalette.white,
                  fontSize: AppFonts.baseSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
