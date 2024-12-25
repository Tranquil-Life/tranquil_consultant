import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class NoVideoRecordState extends StatelessWidget {
  const NoVideoRecordState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: displayWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1, color: ColorPalette.red),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: ColorPalette.green.shade300,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                      width: 1, color: Color(0xFF62B778))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                    SvgElements.svgVideoPlayIcon),
              ),
            ),
          ),
          Text(
            "Record video",
            style: TextStyle(
              color: ColorPalette.gray.shade400,
              fontSize: AppFonts.baseSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
