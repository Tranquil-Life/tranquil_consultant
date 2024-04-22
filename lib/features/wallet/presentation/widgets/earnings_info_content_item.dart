import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class InfoContentItem extends StatelessWidget {
  const InfoContentItem({Key? key, required this.title, required this.amount})
      : super(key: key);

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Flexible(child: Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorPalette.white, fontSize: AppFonts.defaultSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4,
        ),
        SizedBox(
          width: displayWidth(context) * 0.4,
          child: Text(
          amount,
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorPalette.white, fontSize: 22),
        ),
        )
      ],
    )
  );
  }
}
