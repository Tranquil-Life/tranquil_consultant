import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

Widget uploadBox({
  required String label,
  required ui.Image? decodedImage,
  required BuildContext context, // Change parameter to ui.Image
}) {
  return Container(
    width: displayWidth(context),
    height: 100,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(width: 1, color: ColorPalette.grey[800]!),
    ),
    // Use RawImage instead of Image.memory or Image.network
    child: decodedImage == null
        ? _placeholder(label)
        : RawImage(
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
