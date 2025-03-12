import 'dart:ui';

import 'package:get/get.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/growth_kit/domain/entities/growth_resource.dart';

class GrowthKitController extends GetxController{
  static GrowthKitController instance = Get.find();

  var resources = <GrowthResource>[
    GrowthResource(
        image: SvgElements.svgSelfAssess,
        title: "Self-Assessment",
        onTap: (){
          print("Assessment");

        }),

    GrowthResource(
        image: SvgElements.svgPeerSupport,
        title: "Peer support",
        onTap: (){
          print("Peer support");
        }),

    GrowthResource(
        image: SvgElements.svgCourses,
        title: "Courses",
        onTap: (){}),

    GrowthResource(
        image: SvgElements.svgWebinars,
        title: "Webinars",
        onTap: (){}),

    GrowthResource(
        image: SvgElements.svgLibrary,
        title: "Resource library",
        onTap: (){}),

    GrowthResource(
        image: SvgElements.svgAnalytics,
        title: "Analytics",
        onTap: (){}),
  ];


}

