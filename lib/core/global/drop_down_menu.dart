import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';

class DropdownWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final DropdownController controller;
  final Function(String option)? onTap;

  const DropdownWidget({
    super.key,
    required this.title,
    required this.options,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dropdownValue = options.contains(controller.selectedValue.value)
          ? controller.selectedValue.value
          : null;
      return DropdownButton<String>(
        value: dropdownValue,
        style: TextStyle(
          color: ColorPalette.black
        ),
        hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.grey.shade800),
            )),
        underline: const SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down),
        isExpanded: true,
        onChanged: controller.updateValue,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            onTap: onTap!(option),
            value: option,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                option,
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.black),
              ),
            ),
          );
        }).toList(),
        dropdownColor: ColorPalette.white,
      );
    });
  }
}

class DropdownController extends GetxController {
  var selectedValue = ''.obs;
  DropdownController({String initialValue = ""})
      : selectedValue = initialValue.obs;

  void updateValue(String? value) {
    if (value != null) {
      selectedValue.value = value;
    }
  }
}
