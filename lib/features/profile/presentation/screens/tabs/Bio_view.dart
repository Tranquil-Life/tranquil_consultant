import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';

class BioTabView extends StatelessWidget {
  const BioTabView({super.key, this.client});

  final UserModel? client;

  // final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    // return bioFormField(inputBio, profileController.bioTEC);

    return GestureDetector(
      onTap: () => Get.to(const EditProfileScreen()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              "${client!.bio.isEmpty ? noInputBio : client?.bio}",
              style: TextStyle(
                  color: client!.bio.isEmpty
                      ? ColorPalette.gray[800]
                      : ColorPalette.black),
            ),
          ),
          Icon(
            Icons.edit_outlined,
            size: 20,
            color: ColorPalette.green,
          ),
        ],
      ),
    );
  }
}
