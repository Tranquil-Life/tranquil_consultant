import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/app_bar_button.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';

class AppBarAction {
  final Widget child;
  final bool isCustomButton;
  final Function()? onPressed;
  final Color? actionBgColor;

  const AppBarAction( {
    required this.child,
    this.onPressed,
    this.isCustomButton = true,
    this.actionBgColor,
  });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool hideBackButton;
  final Color? backgroundColor;
  final Color? actionBgColor;
  final bool? centerTitle;
  final Color? titleColor;
  final List<AppBarAction>? actions;
  final Function()? onBackPressed;
  final IconData? backIcon;
  final String? fontFamily;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.hideBackButton = false,
    this.actions,
    this.onBackPressed,
    this.centerTitle,
    this.backIcon,
    this.fontFamily,
    this.backgroundColor, this.actionBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      centerTitle: centerTitle,
      toolbarTextStyle: TextStyle(
        fontSize: 17,
        color: ColorPalette.green[800],
        fontFamily: fontFamily,
      ),
      leading: centerTitle == true ? null : (Navigator.of(context).canPop() || onBackPressed != null) &&
              !hideBackButton
          ? Hero(
              tag: 'back_button',
              child: Center(
                child: AppBarButton(
                  backgroundColor: ColorPalette.green,
                  onPressed: onBackPressed ?? Navigator.of(context).pop,
                  icon: const Padding(
                    padding: EdgeInsets.all(1),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      title: title != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? ColorPalette.black,
                  fontFamily: AppFonts.josefinSansRegular
                ),
              ),
            )
          : null,
      actions: actions?.map<Widget>((e) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Center(
            child: e.isCustomButton
                ? AppBarButton(
                icon: e.child,
                onPressed: e.onPressed,
                backgroundColor: actionBgColor ?? ColorPalette.green)
                : _NormalButton(e),
          ),
        );
      }).toList()
        ?..add(const SizedBox(width: 4)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NormalButton extends StatelessWidget {
  const _NormalButton(this.data, {super.key});

  final AppBarAction data;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: ColorPalette.green[800], size: 24),
      ),
      child: GestureDetector(onTap: data.onPressed, child: data.child),
    );
  }
}
