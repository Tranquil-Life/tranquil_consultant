import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';

class InfoContentItem extends StatelessWidget {
  const InfoContentItem({Key? key,
    required this.title, required this.amount}) : super(key: key);

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(title,
          style: TextStyle(
              color: ColorPalette.white,
            fontSize: AppFonts.defaultSize
          ),
        ),
        SizedBox(height: 4,),
        Text(amount,
          style: TextStyle(
              color: ColorPalette.white,
            fontSize: 22
          ),
        ),
      ],
    );
  }
}
