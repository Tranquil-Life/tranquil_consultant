import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class NoEventsWidget extends StatelessWidget {
  const NoEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 100, // Adjust height as needed
          child: SvgPicture.asset(SvgElements.svgNoEventsIcon),
        ),
        Text(
          'No events at the moment',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorPalette.grey[400],
              fontSize: AppFonts.baseSize,
              fontFamily: AppFonts.mulishBold,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'We’ll let you know about upcoming events!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.grey[300],
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }
}
