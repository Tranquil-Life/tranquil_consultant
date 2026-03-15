import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/id_upload_box.dart';

class UploadPassportWidget extends StatelessWidget {
  final EarningsController earningsController;
  final VoidCallback? onChangeType;
  final VoidCallback? onSnapFrontOfID;

  // We keep these for mobile path logic, but we'll use controller for bytes
  final XFile? front;
  final bool? isPassport;

  const UploadPassportWidget({
    super.key,
    required this.earningsController,
    this.front,
    this.isPassport,
    this.onChangeType,
    this.onSnapFrontOfID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Upload Passport',
          style: TextStyle(
            fontFamily: AppFonts.mulishSemiBold,
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: onSnapFrontOfID,
          // Wrap in Obx so it updates when bytes change
          child: Obx(() => uploadBox(
              label: "Front",
              decodedImage: earningsController.decodedFrontImage.value,
              context: context
          )),
        ),
        // GestureDetector(
        //   onTap: onSnapFrontOfID,
        //   child: Container(
        //     height: 100,
        //     width: displayWidth(context),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8.0),
        //         border: Border.all(width: 1, color: ColorPalette.grey[800]!)),
        //     child: front == null
        //         ? Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 SvgPicture.asset(SvgElements.svgImageIcon,
        //                     colorFilter: ColorFilter.mode(
        //                         ColorPalette.grey[800]!, BlendMode.srcIn),
        //                     height: 40,
        //                     width: 40),
        //                 SizedBox(height: 4),
        //                 Text("Front")
        //               ],
        //             ))
        //         : Image.file(front != null ? File(front!.path) : File("")),
        //   ),
        // ),
        SizedBox(height: 12),
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
