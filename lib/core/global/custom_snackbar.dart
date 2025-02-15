import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext? context,
    String? title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title ?? "",
      message,
      borderRadius: 12,
      colorText: Colors.white,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: Duration(milliseconds: max(3000, message.length * 40)),
      animationDuration: const Duration(milliseconds: 400),
      titleText: title != null
          ? Text(
        title,
        style:
        const TextStyle(fontSize: 16.5, color: ColorPalette.white),
      )
          : const SizedBox(),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 14, color: ColorPalette.white),
      ),
    );
  }

  static void errorSnackBar(String errorMsg) {
    if (errorMsg.contains(ApiService.certVerifyFailed)) {
      return showSnackBar(
          context: Get.context!,
          title: "Internet Error",
          message: "Please change your network provider",
          backgroundColor: ColorPalette.red);
    } else if(errorMsg.toLowerCase().contains('unauthenticated')){
      SettingsController().signOut();
    } else {
      return CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: errorMsg,
          backgroundColor: ColorPalette.red);
    }
  }
}
