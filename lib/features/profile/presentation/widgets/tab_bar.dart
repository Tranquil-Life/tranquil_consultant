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
      indicatorColor: ColorPalette.green,
      indicatorPadding: const EdgeInsets.only(left: 20, right: 20),
      labelColor: ColorPalette.green,
      unselectedLabelColor: Colors.grey,
      controller: controller,
      isScrollable: true,
      onTap: whathappensontap,
      tabs: [
        Container(
          height: 20,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            tabviewlabel1 ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Container(
          height: 20,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          child:
              Text(tabviewlabel2 ?? '', style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
