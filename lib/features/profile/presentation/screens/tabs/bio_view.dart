import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class BioTabView extends StatelessWidget {
  BioTabView({super.key});

  final dashboardController = DashboardController.instance;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
      child: SingleChildScrollView( // optional, if bio can be long
        padding: const EdgeInsets.only(right: 8),
        child: Obx(()=>Text(
          dashboardController.bio.value.isEmpty
              ? "Add a bio to let clients know more about you."
              : dashboardController.bio.value,
          softWrap: true,
          style: TextStyle(
            color: dashboardController.bio.value.isEmpty ? ColorPalette.grey[800] : ColorPalette.black,
          ),
        ),)
      ),
    );
  }
}
