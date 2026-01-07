import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tl_consultant/main.dart';

class CustomSnackBar {
  static void showSnackBar({
    String? title,
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = rootMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        duration: duration,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && title.isNotEmpty)
              Text(title,
                  style: const TextStyle(fontSize: 16.5, color: Colors.white)),
            Text(message,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  static void errorSnackBar(String errorMsg) {
    final msg = errorMsg.toLowerCase();
    if (msg.contains('unauthenticated')) return;

    if (errorMsg.contains(ApiService.certVerifyFailed)) {
      showSnackBar(
        title: "Internet Error",
        message: "Please change your network provider",
        backgroundColor: ColorPalette.red,
      );
      return;
    }

    showSnackBar(
      title: "Error",
      message: errorMsg,
      backgroundColor: ColorPalette.red,
    );
  }

  static void successSnackBar({String? title, required String body}) {
    showSnackBar(
      title: title ?? "Success",
      message: body,
      backgroundColor: Colors.green,
    );
  }

  static void neutralSnackBar(String body, {String? title}) {
    if (title != null) {
      showSnackBar(
        title: title,
        message: body,
        backgroundColor: Colors.blue,
      );
    } else {
      showSnackBar(
        message: body,
        backgroundColor: Colors.blue,
      );
    }
  }
}
