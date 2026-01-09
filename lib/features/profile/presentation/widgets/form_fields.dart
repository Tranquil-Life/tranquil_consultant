import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/global/drop_down_menu.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

CustomFormField nameFormField(String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
    textEditingController: controller,
  );
}

CustomFormField titleFormField(
    String hint, ProfileController profileController, Function()? onTap) {
  final dropdownControllerTitle = DropdownController(initialValue: "Psy.D");
  return CustomFormField(
    readOnly: true,
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_down),
    ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField countryFormField(
    String hint, TextEditingController controller) {
  // final dropdownControllerCountry =
  //     DropdownController(initialValue: "United Kingdom");
  return CustomFormField(
    readOnly: true,
    textEditingController: controller,
    // suffix: DropdownWidget(
    //   options: ["United Kingdom", "Nigeria", "Denmark"],
    //   controller: dropdownControllerCountry,
    //   title: "",
    // ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField stateFormField(
    String hint, TextEditingController controller) {
  // final dropdownControllerCity = DropdownController(initialValue: "London");
  return CustomFormField(
    readOnly: true,
    textEditingController: controller,

    // suffix: DropdownWidget(
    //   options: ["London", "Abuja", "Accra"],
    //   controller: dropdownControllerCity,
    //   title: "",
    // ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField bioFormField(String hint, ProfileController profileController) {
  return CustomFormField(
    textEditingController: profileController.bioTEC,
    maxLines: 3,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField nameOfCertification(
    {required String hint,
    Function(String)? onChanged,
    Function(String)? onFieldSubmitted,
    required String text}) {
  return CustomFormField(
    textEditingController: TextEditingController(text: text),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
    // hintColor: text.isNotEmpty ? ColorPalette.black : null,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
  );
}

CustomFormField timezoneField(String value) {
  return CustomFormField(
    textEditingController: TextEditingController(text: value),
    verContentPadding: 12,
    horContentPadding: 12,
  );
}

CustomFormField institutionField(
    {required String hint,
    Function(String)? onChanged,
    Function(String)? onFieldSubmitted,
    required String text}) {
  return CustomFormField(
    textEditingController: TextEditingController(text: text),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
    // hintColor: text.isNotEmpty ? ColorPalette.black : Colors.white,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
  );
}

CustomFormField yearGraduatedField(
    {required String hint,
    Function(String)? onChanged,
    Function(String)? onFieldSubmitted,
    required String text}) {
  return CustomFormField(
    textEditingController: TextEditingController(text: text),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
    // hintColor: text.isNotEmpty ? ColorPalette.black : null,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
  );
}

CustomFormField modalities(
    String hint, ProfileController profileController, Function()? onTap) {
  return CustomFormField(
    // textEditingController: profileController.modalitiesTEC,
    readOnly: true,
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_down),
    ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

