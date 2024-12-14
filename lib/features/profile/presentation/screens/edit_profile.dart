import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/broken_vertical_line.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/drop_down_menu.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/edit_profile_fields.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/qualification_fields.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileController profileController = ProfileController();

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
                EditProfileFields(),
              ],
            ),
          )),
    );
  }
}

class EditProfileHead extends StatelessWidget {
  const EditProfileHead({Key? key}) : super(key: key);

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
                onPressed: () {},
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
