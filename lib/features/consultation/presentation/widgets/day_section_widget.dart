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
    var onBgColor = widget.isSelected ? Colors.white : Colors.black;

    return SizedBox(
      height: isSmallScreen(context) ? 80 : 160,
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: widget.isSelected ? null : widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected ? ColorPalette.green : ColorPalette.white,
            borderRadius: BorderRadius.circular(isSmallScreen(context) ? 16.0 : 32),
            border: widget.isSelected ? Border.all(width: 2, color: ColorPalette.white) : null,

            boxShadow: widget.isSelected ? [
              BoxShadow(
                  blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
            ] : null
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(widget.icon, color: onBgColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.title,
                        style: TextStyle(color: onBgColor, fontSize: isSmallScreen(context) ? 20 : 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}