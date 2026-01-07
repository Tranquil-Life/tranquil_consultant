import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class ExplorePerksWidget extends StatelessWidget {
  const ExplorePerksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          isSmallScreen(context)
              ? SvgElements.svgUpscale
              : SvgElements.svgUpscaleExtended,
          fit: BoxFit.fill,
          height: isSmallScreen(context) ? 128 : 92,
          width: isSmallScreen(context) ? null : displayWidth(context),
        ),
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen(context) ? 12 : 18),
                child: isSmallScreen(context)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore perks prepared to help you \nbecome a mental health expert",
                            style: TextStyle(
                                fontSize: AppFonts.baseSize,
                                color: ColorPalette.white,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 160,
                            height: 40,
                            child: CustomButton(
                                bgColor: ColorPalette.white,
                                onPressed: () {
                                  CustomSnackBar.neutralSnackBar("Coming soon");
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Get started",
                                        style: TextStyle(
                                            color: ColorPalette.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        color: ColorPalette.black,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Explore perks prepared to help \nyou become a mental health expert",
                            style: TextStyle(
                                fontSize: AppFonts.baseSize,
                                color: ColorPalette.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            // width: 232,
                            // height: 48,
                            width: 160,
                            height: 40,
                            child: CustomButton(
                                bgColor: ColorPalette.white,
                                onPressed: () {
                                  CustomSnackBar.neutralSnackBar(
                                      "Coming soon");
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: "Get started",
                                        color: ColorPalette.black,
                                        weight: FontWeight.w600,
                                        // size: 18,
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        color: ColorPalette.black,
                                        // size: 30,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      )))
      ],
    );
  }
}
