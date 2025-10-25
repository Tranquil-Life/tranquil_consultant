import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.size = 50,
    this.padding = const EdgeInsets.all(5),
  });

  final Widget icon;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).primaryColor;
    final isSmall = isSmallScreen(context);

    return SizedBox(
      height: isSmall ? kToolbarHeight : size,
      width: isSmall ? kToolbarHeight : size,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(isSmallScreen(context) ? 9 : 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onPressed,
          child: Padding(
            padding: padding,
            child: IconTheme(
              data: const IconThemeData(color: Colors.white, size: 22),
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}

class BackButtonWhite extends StatelessWidget {
  const BackButtonWhite({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'back_button',
      child: AppBarButton(
        backgroundColor: Colors.white,
        icon: const Padding(
          padding: EdgeInsets.all(1),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: ColorPalette.green,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}