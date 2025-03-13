import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.icon, this.onPressed, this.showBorder});

  final Widget icon;
  final Function()? onPressed;
  final bool? showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: showBorder == true ? Border.all(color: ColorPalette.grey) : null
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: onPressed,
          child: Padding(padding: const EdgeInsets.all(6), child: icon),
        ),
      ),
    );
  }
}