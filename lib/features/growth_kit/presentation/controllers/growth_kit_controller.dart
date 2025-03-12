import 'dart:ui';

import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/growth_kit/domain/entities/growth_resource.dart';

class GrowthKitController extends GetxController {
  static GrowthKitController instance = Get.find();

  var resources = <GrowthResource>[
    GrowthResource(
        image: SvgElements.svgSelfAssess,
        title: "Self-Assessment",
        onTap: () {
          CustomSnackBar.showSnackBar(
              context: Get.context,
              message: "Coming soon",
              backgroundColor: ColorPalette.blue);
        }),
    GrowthResource(
        image: SvgElements.svgPeerSupport,
        title: "Peer support",
        onTap: () {
          CustomSnackBar.showSnackBar(
              context: Get.context,
              message: "Coming soon",
              backgroundColor: ColorPalette.blue);
        }),
    GrowthResource(
        image: SvgElements.svgCourses, title: "Courses", onTap: () {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          message: "Coming soon",
          backgroundColor: ColorPalette.blue);
    }),
    GrowthResource(
        image: SvgElements.svgWebinars, title: "Webinars", onTap: () {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          message: "Coming soon",
          backgroundColor: ColorPalette.blue);
    }),
    GrowthResource(
        image: SvgElements.svgLibrary, title: "Resource library", onTap: () {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          message: "Coming soon",
          backgroundColor: ColorPalette.blue);
    }),
    GrowthResource(
        image: SvgElements.svgAnalytics, title: "Analytics", onTap: () {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          message: "Coming soon",
          backgroundColor: ColorPalette.blue);
    }),
  ];
}
