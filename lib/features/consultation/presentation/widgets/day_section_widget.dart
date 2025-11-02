import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class DaySectionWidget extends StatefulWidget {
  const DaySectionWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool isSelected;
  final Function() onPressed;

  @override
  State<DaySectionWidget> createState() => DaySectionWidgetState();
}

class DaySectionWidgetState extends State<DaySectionWidget> {
  @override
  Widget build(BuildContext context) {
    final onBgColor = widget.isSelected ? Colors.white : Colors.black;
    final isSmall = isSmallScreen(context);

    return SizedBox(
      height: isSmall ? 60 : 90, // reduced from 80/160
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: widget.isSelected ? null : widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected ? ColorPalette.green : ColorPalette.white,
            borderRadius: BorderRadius.circular(isSmall ? 12.0 : 20.0),
            border: widget.isSelected
                ? Border.all(width: 2, color: ColorPalette.green.withOpacity(.7))
                : Border.all(width: 1, color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: isSmall ? 20 : 28,
                  color: onBgColor,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: onBgColor,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmall ? 16 : 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
