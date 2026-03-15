import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/id_upload_box.dart';

class UploadIdWidget extends StatelessWidget {
  final EarningsController earningsController;
  final VoidCallback? onChangeType;
  final VoidCallback? onSnapFrontOfID;
  final VoidCallback? onSnapBackOfID;

  // We keep these for mobile path logic, but we'll use controller for bytes
  final XFile? front;
  final XFile? back;
  final bool? isPassport;

  const UploadIdWidget({
    super.key,
    required this.earningsController,
    this.front,
    this.back,
    this.isPassport,
    this.onChangeType,
    this.onSnapFrontOfID,
    this.onSnapBackOfID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Upload ID (e.g driver's license, etc...)",
          style: TextStyle(fontFamily: AppFonts.mulishSemiBold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onSnapFrontOfID,
                // Wrap in Obx so it updates when bytes change
                child: Obx(() => uploadBox(
                    label: "Front",
                    decodedImage: earningsController.decodedFrontImage.value,
                    context: context)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: onSnapBackOfID,
                child: Obx(() => uploadBox(
                    label: "Back",
                    decodedImage: earningsController.decodedBackImage.value,
                    context: context)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _changeTypeButton(),
      ],
    );
  }

  Widget _changeTypeButton() {
    return GestureDetector(
      onTap: onChangeType,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: ColorPalette.green[100],
            borderRadius: BorderRadius.circular(100)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Change document type",
                style: TextStyle(
                    color: ColorPalette.green,
                    fontFamily: AppFonts.mulishSemiBold)),
            const SizedBox(width: 4),
            Icon(Icons.swap_horiz, color: ColorPalette.green[600], size: 18)
          ],
        ),
      ),
    );
  }
}
