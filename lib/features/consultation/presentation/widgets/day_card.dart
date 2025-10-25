import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class DayCard extends StatelessWidget {
  const DayCard(this.day, {Key? key, this.onChosen, required this.selected})
      : super(key: key);

  final Function()? onChosen;
  final bool selected;
  final String day;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChosen,
      child: Container(
          width: isSmallScreen(context) ? 80 : 160,
          decoration: BoxDecoration(
              color: selected ? ColorPalette.green : ColorPalette.grey,
              borderRadius: BorderRadius.circular(isSmallScreen(context) ? 16.0 : 32),
              border: !selected
                  ? Border.all(width: 2, color: ColorPalette.white)
                  : null,
              boxShadow: !selected
                  ? [
                      BoxShadow(
                          blurRadius: 6,
                          color: Colors.black12,
                          offset: Offset(0, 3)),
                    ]
                  : null),
          child: Center(
            child: CustomText(
                text: day.substring(0, 3),
                color: selected ? Colors.white : ColorPalette.black,
                weight: FontWeight.w700,
                size: isSmallScreen(context) ? AppFonts.defaultSize : 18),
          )),
    );
  }
}
