import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
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
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.02,
            vertical: size.height * 0.001,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                height: iconSize,
                width: 24,
                color: isSelected
                    ? const Color(0xFF388D4D)
                    : ColorPalette.grey[700],
              ),
              SizedBox(height: size.height * 0.006),
              Text(
                label,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.03,
                  color: isSelected
                      ? const Color(0xFF388D4D)
                      : ColorPalette.grey[700],
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
