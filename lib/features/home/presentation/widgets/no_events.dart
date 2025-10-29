import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class NoEventsWidget extends StatelessWidget {
  const NoEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 32),
        SvgPicture.asset(SvgElements.svgNoEventsIcon),
        // SvgPicture.asset(SvgElements.svgNoEventsIcon,
        //     height: isSmallScreen(context) ? null : 80),
        SizedBox(height: isSmallScreen(context) ? 12 : 24),

        Text(
          'No events at the moment',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorPalette.grey[400],
              fontSize: AppFonts.baseSize,
              // fontSize: isSmallScreen(context) ? AppFonts.baseSize : 20,
              fontFamily: AppFonts.mulishBold,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'We’ll let you know about upcoming events!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.grey[300],
            fontSize: AppFonts.defaultSize
            // fontSize: isSmallScreen(context)
            //     ? AppFonts.defaultSize
            //     : AppFonts.baseSize,
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }
}
