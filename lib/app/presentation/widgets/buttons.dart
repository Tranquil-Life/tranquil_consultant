import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class CustomButton extends StatelessWidget{
  final String? text;
  final Widget? child;
  final Function()? onPressed;
  const CustomButton({Key? key,
    this.text,
    required this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.green,
        minimumSize: Size(displayWidth(context), 56),
        elevation: 4,
        shadowColor: ColorPalette.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
        ),
      ),
      onPressed: onPressed,
      child: child ?? Text(text!, style: const TextStyle(fontSize: AppFonts.defaultSize)),
    );
  }
}

class WidgetsThemeData {
  final Color primaryColor;
  WidgetsThemeData({required this.primaryColor})
      : textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: primaryColor),
  ),
        outlinedButtonTheme = OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(380, 56),
            padding: const EdgeInsets.all(12),
            side: BorderSide(width: 1.5, color: primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

  final TextButtonThemeData textButtonTheme;
  final OutlinedButtonThemeData outlinedButtonTheme;

  final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(380, 56),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  static const inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Color(0xffF1F1F1),
    hintStyle: TextStyle(color: Colors.grey, height: 1.2),
    errorStyle: TextStyle(fontSize: 14, color: Color.fromARGB(255, 241, 0, 0)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color.fromARGB(255, 226, 224, 224)),
    ),
    contentPadding: EdgeInsets.all(24),
  );
  static const dropDownShadow = [
    BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Colors.black12)
  ];
}