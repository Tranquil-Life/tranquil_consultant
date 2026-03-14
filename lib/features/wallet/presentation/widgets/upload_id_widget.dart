import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

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
                child: Obx(() => _uploadBox(
                      label: "Front",
                      decodedImage: earningsController.decodedFrontImage.value,
                    )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: onSnapBackOfID,
                child:  Obx(() => _uploadBox(
                  label: "Back",
                  decodedImage: earningsController.decodedBackImage.value,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _changeTypeButton(),
      ],
    );
  }

// Update the _uploadBox definition:
  Widget _uploadBox({
    required String label,
    required ui.Image? decodedImage, // Change parameter to ui.Image
  }) {
    return Container(
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1, color: ColorPalette.grey[800]!),
      ),
      // Use RawImage instead of Image.memory or Image.network
      child: decodedImage == null
          ? _placeholder(label)
          :
      RawImage(
              image: decodedImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  Widget _placeholder(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SvgElements.svgImageIcon,
            colorFilter:
                ColorFilter.mode(ColorPalette.grey[800]!, BlendMode.srcIn),
            height: 30,
            width: 30,
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
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
