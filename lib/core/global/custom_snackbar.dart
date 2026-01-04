import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';

class CustomSnackBar {
  static void showSnackBar(
      {required BuildContext? context,
      String? title,
      required String message,
      required Color backgroundColor,
      SnackPosition? snackPosition = SnackPosition.BOTTOM,
      Duration? duration = const Duration(seconds: 3)}) {
    Get.snackbar(
      title ?? "",
      message,
      borderRadius: 12,
      colorText: Colors.white,
      backgroundColor: backgroundColor,
      snackPosition: snackPosition,
      margin: const EdgeInsets.all(12),
      duration: duration,
      animationDuration: const Duration(milliseconds: 400),
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(fontSize: 16.5, color: ColorPalette.white),
            )
          : const SizedBox(),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 14, color: ColorPalette.white),
      ),
    );
  }

  static void errorSnackBar(String errorMsg) {
    final msg = errorMsg.toLowerCase();

    if (msg.contains('unauthenticated')) {
      // do nothing
      return;
    } else if (errorMsg.contains(ApiService.certVerifyFailed)) {
      return CustomSnackBar.showSnackBar(
        context: Get.context!,
        title: "Internet Error",
        message: "Please change your network provider",
        backgroundColor: ColorPalette.red,
      );
    } else {
      return CustomSnackBar.showSnackBar(
        context: Get.context!,
        title: "Error",
        message: errorMsg,
        backgroundColor: ColorPalette.red,
      );
    }
  }

  static void successSnackBar({String? title, required String body}) {
    return CustomSnackBar.showSnackBar(
        context: Get.context!,
        title: title ?? "Success",
        message: body,
        backgroundColor: Colors.green);
  }
}
