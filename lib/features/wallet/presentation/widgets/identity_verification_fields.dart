import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/upload_id_widget.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/upload_passport_widget.dart';

class IdentityVerificationFields extends StatefulWidget {
  const IdentityVerificationFields(
      {super.key, required this.earningsController});

  final EarningsController earningsController;

  @override
  State<IdentityVerificationFields> createState() =>
      _IdentityVerificationFieldsState();
}

class _IdentityVerificationFieldsState
    extends State<IdentityVerificationFields> {
  File? front;
  File? back;

  bool? isPassport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("IDENTITY VERIFICATION",
            style: TextStyle(fontSize: AppFonts.baseSize)),
        SizedBox(height: 12),
        Text(
          "Upload a valid document",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 12),
        if (isPassport == null && front == null && back == null)
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                      onPressed: () async {
                        front = null;
                        back = null;

                        isPassport = true;

                        setState(() {});
                      },
                      bgColor: ColorPalette.white,
                      showBorder: true,
                      text: "Passport",
                      textColor: ColorPalette.green)),
              SizedBox(width: 8),
              Expanded(
                  child: CustomButton(
                      onPressed: () {
                        front = null;
                        back = null;

                        isPassport = false;

                        setState(() {});
                      },
                      bgColor: ColorPalette.white,
                      showBorder: true,
                      text: "Other",
                      textColor: ColorPalette.green))
            ],
          ),
        if (isPassport == true && (front == null || back == null))
          UploadPassportWidget(
              earningsController: widget.earningsController,
              front: front,
              back: back,
              isPassport: isPassport,
              onSnapFrontOfID: () async {
                front = await MediaService.openCamera();

                if (front != null) {
                  widget.earningsController.frontIdPath.value = front!.path;
                }

                setState(() {});
              },
              onChangeType: () {
                if (isPassport != null) {
                  isPassport = !isPassport!;
                }

                front = null;
                back = null;

                setState(() {});
              }),

        if (isPassport == false && front == null && back == null)
          UploadIdWidget(
            earningsController: widget.earningsController,
            front: front,
            back: back,
            isPassport: isPassport,
            onSnapFrontOfID: () async {
              front = await MediaService.openCamera();

              if (front != null) {
                widget.earningsController.frontIdPath.value = front!.path;
              }

              setState(() {});
            },
            onSnapBackOfID: () async {
              back = await MediaService.openCamera();

              if (back != null) {
                widget.earningsController.backIdPath.value = back!.path;
              }

              setState(() {});
            },
            onChangeType: () {
              if (isPassport != null) {
                isPassport = true;
              }

              front = null;
              back = null;

              setState(() {});
            },
          ),
        if (isPassport == false && (front != null || back != null))
          UploadIdWidget(
            earningsController: widget.earningsController,
            front: front,
            back: back,
            isPassport: isPassport,
            onSnapFrontOfID: () async {
              front = await MediaService.openCamera();

              if (front != null) {
                widget.earningsController.frontIdPath.value = front!.path;
              }

              setState(() {});
            },
            onSnapBackOfID: () async {
              back = await MediaService.openCamera();

              if (back != null) {
                widget.earningsController.backIdPath.value = back!.path;
              }

              setState(() {});
            },
            onChangeType: () {
              if (isPassport != null) {
                isPassport = true;
              }

              front = null;
              back = null;

              setState(() {});
            },
          )
      ],
    );
  }
}
