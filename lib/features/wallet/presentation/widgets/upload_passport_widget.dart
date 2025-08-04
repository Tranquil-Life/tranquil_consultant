import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

class UploadPassportWidget extends StatelessWidget {
  UploadPassportWidget(
      {super.key,
      required this.earningsController,
      this.front,
      this.back,
      this.isPassport, this.onChangeType, this.onSnapFrontOfID});

  final EarningsController earningsController;
  File? front;
  File? back;
  bool? isPassport;
  final Function()? onChangeType;
  final Function()? onSnapFrontOfID;

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
          child: Container(
            height: 100,
            width: displayWidth(context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1, color: ColorPalette.grey[800]!)),
            child: front == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(SvgElements.svgImageIcon,
                            colorFilter: ColorFilter.mode(
                                ColorPalette.grey[800]!, BlendMode.srcIn),
                            height: 40,
                            width: 40),
                        SizedBox(height: 4),
                        Text("Front")
                      ],
                    ))
                : Image.file(front!),
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: onChangeType,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: ColorPalette.green[100],
              borderRadius: BorderRadius.circular(100)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Change document type",
                  style: TextStyle(
                      color: ColorPalette.green,
                      fontFamily: AppFonts.mulishSemiBold),
                ),
                SizedBox(width: 4),
                Icon(Icons.swap_horiz, color: ColorPalette.green[600])
              ],
            ),
          ),
        )
      ],
    );
  }
}
