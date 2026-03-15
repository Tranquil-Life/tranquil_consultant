import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
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
  XFile? front;
  XFile? back;

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
              isPassport: isPassport,
              onSnapFrontOfID: () async {
                final XFile? picked = await MediaService.openCamera();
                if (picked != null) {
                  // 1. Get raw bytes
                  final bytes = await picked.readAsBytes();

                  print("Front ID bytes length: ${bytes.length}"); // Debug log

                  // 2. Manually decode to bypass the browser's ImageDecoder bug
                  final decoded = await decodeImageFromList(bytes);

                  print(
                      "Decoded image dimensions: ${decoded.width}x${decoded.height}"); // Debug log

                  // 3. Store both in the controller
                  widget.earningsController.decodedFrontImage.value = decoded;
                  widget.earningsController.frontIdBytes.value = bytes;

                  print(
                      "Front ID bytes stored in controller: ${widget.earningsController.frontIdBytes.value != null}"); // Debug log
                  print(
                      "Decoded image stored in controller: ${widget.earningsController.decodedFrontImage.value != null}"); // Debug log

                  // Trigger local setState if you're using 'front' variable locally
                  setState(() {
                    front = picked;
                  });

                  print("Front ID path: ${picked.path}"); // Debug log
                }
              },
              onChangeType: () {
                setState(() {
                  isPassport = !(isPassport ?? false);
                  front = null;
                  back = null;
                  // Clear controller data too
                  widget.earningsController.frontIdBytes.value = null;
                  widget.earningsController.backIdBytes.value = null;
                });
              }),
        if (isPassport == false && front == null && back == null)
          ///nEW uPLOAD ID Widget for non-passport types, since we need to support single-sided uploads
          UploadIdWidget(
            earningsController: widget.earningsController,
            front: front,
            // Still passing for mobile/path logic if needed
            back: back,
            isPassport: isPassport,
            onSnapFrontOfID: () async {
              final XFile? picked = await MediaService.openCamera();
              if (picked != null) {
                // 1. Get raw bytes
                final bytes = await picked.readAsBytes();

                print("Front ID bytes length: ${bytes.length}"); // Debug log

                // 2. Manually decode to bypass the browser's ImageDecoder bug
                final decoded = await decodeImageFromList(bytes);

                print(
                    "Decoded image dimensions: ${decoded.width}x${decoded.height}"); // Debug log

                // 3. Store both in the controller
                widget.earningsController.decodedFrontImage.value = decoded;
                widget.earningsController.frontIdBytes.value = bytes;

                print(
                    "Front ID bytes stored in controller: ${widget.earningsController.frontIdBytes.value != null}"); // Debug log
                print(
                    "Decoded image stored in controller: ${widget.earningsController.decodedFrontImage.value != null}"); // Debug log

                // Trigger local setState if you're using 'front' variable locally
                setState(() {
                  front = picked;
                });

                print("Front ID path: ${picked.path}"); // Debug log
              }
            },
            onSnapBackOfID: () async {
              final XFile? picked = await MediaService.openCamera();
              if (picked != null) {
                // 1. Get raw bytes
                final bytes = await picked.readAsBytes();

                print("Back ID bytes length: ${bytes.length}"); // Debug log

                // 2. Manually decode to bypass the browser's ImageDecoder bug
                final decoded = await decodeImageFromList(bytes);

                print(
                    "Decoded image dimensions: ${decoded.width}x${decoded.height}"); // Debug log

                // 3. Store both in the controller
                widget.earningsController.decodedBackImage.value = decoded;
                widget.earningsController.backIdBytes.value = bytes;

                print(
                    "Back ID bytes stored in controller: ${widget.earningsController.backIdBytes.value != null}"); // Debug log
                print(
                    "Decoded image stored in controller: ${widget.earningsController.decodedBackImage.value != null}"); // Debug log

                // Trigger local setState if you're using 'front' variable locally
                setState(() {
                  back = picked;
                });

                print("Back ID path: ${picked.path}"); // Debug log
              }
            },
            onChangeType: () {
              setState(() {
                isPassport = !(isPassport ?? false);
                front = null;
                back = null;
                // Clear controller data too
                widget.earningsController.frontIdBytes.value = null;
                widget.earningsController.backIdBytes.value = null;
              });
            },
          ),
        if (isPassport == false && (front != null || back != null))
          UploadIdWidget(
            earningsController: widget.earningsController,
            front: front,
            // Still passing for mobile/path logic if needed
            back: back,
            isPassport: isPassport,
            onSnapFrontOfID: () async {
              final XFile? picked = await MediaService.openCamera();
              if (picked != null) {
                // 1. Get raw bytes
                final bytes = await picked.readAsBytes();

                print("Front ID bytes length: ${bytes.length}"); // Debug log

                // 2. Manually decode to bypass the browser's ImageDecoder bug
                final decoded = await decodeImageFromList(bytes);

                print(
                    "Decoded image dimensions: ${decoded.width}x${decoded.height}"); // Debug log

                // 3. Store both in the controller
                widget.earningsController.decodedFrontImage.value = decoded;
                widget.earningsController.frontIdBytes.value = bytes;

                print(
                    "Front ID bytes stored in controller: ${widget.earningsController.frontIdBytes.value != null}"); // Debug log
                print(
                    "Decoded image stored in controller: ${widget.earningsController.decodedFrontImage.value != null}"); // Debug log

                // Trigger local setState if you're using 'front' variable locally
                setState(() {
                  front = picked;
                });

                print("Front ID path: ${picked.path}"); // Debug log
              }
            },
            onSnapBackOfID: () async {
              final XFile? picked = await MediaService.openCamera();
              if (picked != null) {
                // 1. Get raw bytes
                final bytes = await picked.readAsBytes();

                print("Back ID bytes length: ${bytes.length}"); // Debug log

                // 2. Manually decode to bypass the browser's ImageDecoder bug
                final decoded = await decodeImageFromList(bytes);

                print(
                    "Decoded image dimensions: ${decoded.width}x${decoded.height}"); // Debug log

                // 3. Store both in the controller
                widget.earningsController.decodedBackImage.value = decoded;
                widget.earningsController.backIdBytes.value = bytes;

                print(
                    "Back ID bytes stored in controller: ${widget.earningsController.backIdBytes.value != null}"); // Debug log
                print(
                    "Decoded image stored in controller: ${widget.earningsController.decodedBackImage.value != null}"); // Debug log

                // Trigger local setState if you're using 'front' variable locally
                setState(() {
                  back = picked;
                });

                print("Back ID path: ${picked.path}"); // Debug log
              }
            },
            onChangeType: () {
              setState(() {
                isPassport = !(isPassport ?? false);
                front = null;
                back = null;
                // Clear controller data too
                widget.earningsController.frontIdBytes.value = null;
                widget.earningsController.backIdBytes.value = null;
              });
            },
          ),
      ],
    );
  }
}
