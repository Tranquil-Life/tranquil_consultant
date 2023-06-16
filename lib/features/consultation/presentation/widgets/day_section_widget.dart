import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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
      height: 80,
      child: InkResponse(
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        onTap: widget.isSelected ? null : widget.onPressed,
        child: VxBox(
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
                        style: TextStyle(color: onBgColor, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).rounded.p8
            .alignCenter
            .neumorphic(
            color: widget.isSelected ? Colors.green: Colors.white,
            elevation: 12,
            curve: VxCurve.emboss
        ).make(),
      ),
    );
  }
}