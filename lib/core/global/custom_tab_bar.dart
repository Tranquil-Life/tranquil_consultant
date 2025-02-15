import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';

class CustomTabbar extends StatelessWidget {
  final TabController? controller;

  final Function(int) onTap;
  final String? labelOne;
  final String? labelTwo;

  const CustomTabbar({
    Key? key,
    this.controller,
    required this.onTap,
    required this.labelOne,
    required this.labelTwo,
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
      onTap: onTap,
      tabs: [
        Container(
          height: 20,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          child: Text(
            labelOne ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Container(
          height: 20,
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          child:
              Text(labelTwo ?? '', style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
