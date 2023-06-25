import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.iconData,
    this.label,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  final String? label;
  final IconData iconData;
  final bool? isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final color =
    isSelected ?? true ? ColorPalette.green : Colors.grey[600];
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(iconData, size: 28, color: color),
          ),
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}