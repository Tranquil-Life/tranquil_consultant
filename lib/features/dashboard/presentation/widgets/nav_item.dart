import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

class BuildNavItem extends StatelessWidget {
  const BuildNavItem(
      {super.key,
        required this.index,
        required this.icon,
        required this.label,
        required this.size,
        required this.iconSize,
        required this.dashboardController,
        required this.isSelected, required this.onTap});

  final int index;
  final VoidCallback onTap;
  final String icon;
  final String label;
  final Size size;
  final double iconSize;
  final bool isSelected;
  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: isSmallScreen(context) ? EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.02,
            vertical: size.height * 0.001,
          ) : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                height: 24,
                width: 24,
                color: isSelected
                    ? const Color(0xFF388D4D)
                    : ColorPalette.grey[700],
              ),
              SizedBox(height: size.height * 0.006),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen(context) ? AppFonts.smallSize : AppFonts.defaultSize,
                  color: isSelected
                      ?  ColorPalette.grey[400]
                      : ColorPalette.grey[700],
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
