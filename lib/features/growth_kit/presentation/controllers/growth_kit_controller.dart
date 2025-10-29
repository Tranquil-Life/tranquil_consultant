import 'dart:ui';

import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/growth_kit/domain/entities/growth_resource.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class GrowthKitController extends GetxController {
  static GrowthKitController get instance => Get.find();

  onTap() async {
    var isEmpty = await checkForEmptyProfileInfo();
    if (isEmpty) {
      Get.to(() => EditProfileScreen());
    } else {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          message: "Coming soon",
          backgroundColor: ColorPalette.blue);
    }
  }

  var resources = <GrowthResource>[];

  @override
  void onInit() {
    super.onInit();

    resources.addAll([
      GrowthResource(
          image: SvgElements.svgSelfAssess,
          title: "Self-Assessment",
          onTap: onTap),
      GrowthResource(
          image: SvgElements.svgPeerSupport,
          title: "Peer support",
          onTap: onTap),
      GrowthResource(
          image: SvgElements.svgCourses, title: "Courses", onTap: onTap),
      GrowthResource(
          image: SvgElements.svgWebinars, title: "Webinars", onTap: onTap),
      GrowthResource(
          image: SvgElements.svgLibrary,
          title: "Resource library",
          onTap: onTap),
      GrowthResource(
          image: SvgElements.svgAnalytics, title: "Analytics", onTap: onTap),
    ]);
  }
}
