import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext? context,
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      borderRadius: 12,
      colorText: Colors.white,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: Duration(milliseconds: max(1000, message.length * 40)),
      animationDuration: const Duration(milliseconds: 400),
      titleText: Text(
        title,
        style: const TextStyle(fontSize: 16.5, color: ColorPalette.white),
      ),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 14, color: ColorPalette.white),
      ),
    );
  }
}
