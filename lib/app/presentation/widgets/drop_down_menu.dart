import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';

class DropdownWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final DropdownController controller;

  const DropdownWidget({
    Key? key,
    required this.title,
    required this.options,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dropdownValue = options.contains(controller.selectedValue.value)
          ? controller.selectedValue.value
          : null;
      return DropdownButton<String>(
        value: dropdownValue,
        hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.gray.shade800),
            )),
        underline: const SizedBox(),
        icon: SvgPicture.asset(
          "assets/images/icons/arrow_down.svg",
          color: ColorPalette.black,
          height: 16,
          width: 12,
        ),
        isExpanded: true,
        onChanged: controller.updateValue,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                option,
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.gray.shade800),
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
