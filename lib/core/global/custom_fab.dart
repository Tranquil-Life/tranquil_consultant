import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, required this.onChatTap, required this.dbController});

  final VoidCallback onChatTap;
  final DashboardController dbController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorPalette.white,
      elevation: 2,
      shape: const CircleBorder(),
      onPressed: onChatTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(SvgElements.svgChat),
                Positioned(
                  right: -2,
                    child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                   color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ))
              ],
            ),
            Text("Chats", style: TextStyle(fontSize: 12, color: ColorPalette.grey[700]),)
          ],
        )
      ),
    );
  }
}
