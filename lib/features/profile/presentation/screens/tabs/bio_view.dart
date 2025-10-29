import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class BioTabView extends StatelessWidget {
  BioTabView({super.key});

  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final txt = profileController.bioTEC.text;

    return InkWell(
      onTap: () => Get.to(const EditProfileScreen()),
      child: SingleChildScrollView( // optional, if bio can be long
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          txt.isEmpty ? noInputBio : txt,
          softWrap: true,
          style: TextStyle(
            color: txt.isEmpty ? ColorPalette.grey[800] : ColorPalette.black,
          ),
        ),
      ),
    );
  }
}
