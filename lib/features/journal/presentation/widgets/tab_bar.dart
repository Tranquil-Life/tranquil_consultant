import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';

class CustomTabbar extends StatelessWidget {
  final TabController? controller;
  final Function(int) whathappensontap;
  final String? tabviewlabel1;
  final String? tabviewlabel2;

  const CustomTabbar({
    Key? key,
    this.controller,
    required this.whathappensontap,
    required this.tabviewlabel1,
    required this.tabviewlabel2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: ColorPalette.green,

      dividerHeight: 4,
      indicatorWeight: 10,
      indicator: const BoxDecoration(
        color: ColorPalette.green, // Green background for the selected tab
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)), // Rounded corners
      ),
      indicatorSize: TabBarIndicatorSize.tab, // Match tab size
      // indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
      labelColor: ColorPalette.white, // Text color of the selected tab
      unselectedLabelColor: ColorPalette.black, // Text color of unselected tabs
      controller: controller,
      isScrollable: true,
      onTap: whathappensontap,
      tabs: [
        Container(
          height: 20,
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            tabviewlabel1 ?? '',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: 20,
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            tabviewlabel2 ?? '',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
