import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class PictureUploadOption extends StatelessWidget {
  const PictureUploadOption(
      {super.key,
      required this.authController,
      this.onTap,
      required this.selected});

  final AuthController authController;
  final Function()? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 83,
        padding: const EdgeInsets.all(12),
        width: displayWidth(context),
        decoration: BoxDecoration(
          color:
              selected ? ColorPalette.green[200] : ColorPalette.green.shade300,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1, color: ColorPalette.grey.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border:
                              Border.all(width: 1, color: Color(0xFF62B778))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(SvgElements.svgImageIcon),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile picture',
                          style: TextStyle(
                            color: ColorPalette.grey.shade400,
                            fontSize: AppFonts.baseSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context) / 2,
                          child: Text(
                            "Upload a profile picture for your clients",
                            style: TextStyle(
                              color: ColorPalette.grey.shade300,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (authController.profilePic.value.isNotEmpty) {
                return SvgPicture.asset(SvgElements.svgDoubleCheckmarkIcon);
              } else {
                return SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
