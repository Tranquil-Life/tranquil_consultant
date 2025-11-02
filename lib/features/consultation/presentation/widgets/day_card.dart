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
    final isSmall = isSmallScreen(context);
    return GestureDetector(
      onTap: onChosen,
      child: Container(
        width: isSmall ? 66 : 88, // was 80/160
        height: isSmall ? 36 : 40, // explicit compact height
        decoration: BoxDecoration(
          color: selected ? ColorPalette.green : Colors.white,
          borderRadius: BorderRadius.circular(isSmall ? 10 : 12), // was 16/32
          border: Border.all(
            width: 1,
            color: selected ? ColorPalette.green : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Center(
          child: Text(
            day.substring(0, 3).toUpperCase(),
            style: TextStyle(
              color: selected ? Colors.white : ColorPalette.black,
              fontWeight: FontWeight.w700,
              fontSize: isSmall ? 12 : 13, // smaller text
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}
