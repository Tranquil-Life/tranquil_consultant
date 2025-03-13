import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class NoMeetingsWidget extends StatelessWidget {
  const NoMeetingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 10, 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SvgPicture.asset(SvgElements.svgNoMeetingIcon, height: isSmallScreen(context) ? null : 80),
          ),
          const SizedBox(height: 40),
          Text(
            'No meetings scheduled',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorPalette.grey[400],
                fontSize: isSmallScreen(context) ? AppFonts.baseSize : 20,
                fontFamily: AppFonts.mulishBold,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'You don’t have any scheduled sessions with clients yet',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: isSmallScreen(context)
                    ? AppFonts.defaultSize
                    : AppFonts.baseSize,
                fontFamily: AppFonts.mulishRegular),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
