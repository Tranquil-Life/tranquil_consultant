import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.prefix,
    required this.suffix,
  });

  final String label;
  final String prefix;
  final String suffix;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontFamily: AppFonts.mulishRegular,
          inherit: true, // explicit
        ),
        child: InkResponse(
          onTap: onPressed,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 14),
            child: Row(
              children: [
                SvgPicture.asset(prefix, color: ColorPalette.grey[300]),
                const SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: AppFonts.defaultSize), // merges with above
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(suffix),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
