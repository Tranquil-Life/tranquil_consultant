import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';

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
          width: 80,
          height: 40,
          decoration: BoxDecoration(
              color: selected ? ColorPalette.green : ColorPalette.gray,
              borderRadius: BorderRadius.circular(16.0),
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
            child: Text(
              day.substring(0, 3),
              style: TextStyle(
                  color: Colors.white, fontSize: AppFonts.defaultSize),
            ),
          )),
    );
  }
}
