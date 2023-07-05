import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';

class TitleSection extends StatefulWidget {
  const TitleSection({Key? key}) : super(key: key);

  @override
  State<TitleSection> createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Text("Earnings",
          style: TextStyle(
            fontSize: 21,
            fontFamily: AppFonts.josefinSansBold,
            fontWeight: FontWeight.w600,
            color: ColorPalette.black
          ),),
        ),
      ],
    );
  }
}