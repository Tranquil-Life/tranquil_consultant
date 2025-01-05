import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key, this.appBar, this.appBarTitle, this.hideBackButton = false, required this.content});

  final PreferredSizeWidget? appBar;
  final String? appBarTitle;
  final bool hideBackButton;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorPalette.scaffoldColor,
      appBar: appBar ??
          CustomAppBar(
            title: appBarTitle,
            centerTitle: false,
            onBackPressed: hideBackButton == true ? null : () => Get.back(),
          ),
          body: SafeArea(
            child: SizedBox(
              child: Stack(
                children: [
                  Positioned(
                    bottom: displayHeight(context) / 30,
                    // Shifts the image to the bottom
                    right: 0,
                    // Shifts the image to the right
                    child: SvgPicture.asset(
                      SvgElements.svgPlantImage,
                      width: 400, // Adjust size as needed
                      height: 350, // Adjust size as needed
                      fit: BoxFit.contain, // Ensure proportions are maintained
                    ),
                  ),

                  content
                ],
              ),
            ),
          ),
    ));
  }
}
