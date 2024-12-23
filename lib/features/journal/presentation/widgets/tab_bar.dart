import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final Function(int) onTap;
  final String? label1;
  final String? label2;

  const CustomTabBar({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.label1,
    required this.label2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: ColorPalette.green,
      dividerHeight: 2,
      indicatorWeight: 10,
      indicator: const BoxDecoration(
        color: ColorPalette.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: ColorPalette.white,
      unselectedLabelColor: ColorPalette.black,
      controller: controller,
      isScrollable: true,
      onTap: onTap,
      tabAlignment: TabAlignment.start,
      tabs: [
        Container(
          height: 20,
          width: 150,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          padding: EdgeInsets.only(left: controller.index == 0 ? 5 : 40 ),
          child: Text(
            label1 ?? '',
            style: const TextStyle(fontSize: AppFonts.baseSize),
          ),
        ),
        Container(
          height: 20,
          width: 150,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            label2 ?? '',
            style: const TextStyle(fontSize: AppFonts.baseSize),
          ),
        ),
      ],
    );
  }
}
