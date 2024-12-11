import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/app/presentation/widgets/drop_down_menu.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

CustomFormField nameFormField(String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
    textEditingController: controller,
  );
}

CustomFormField titleFormField(
  String hint,
) {
  final dropdownControllerTitle = DropdownController(initialValue: "Psy.D");
  return CustomFormField(
    readOnly: true,
    suffix: DropdownWidget(
      options: ["Psy.D"],
      controller: dropdownControllerTitle,
      title: "",
    ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField countryFormField(
  String hint,
) {
  final dropdownControllerCountry =
      DropdownController(initialValue: "United Kingdom");
  return CustomFormField(
    readOnly: true,
    suffix: DropdownWidget(
      options: ["United Kingdom", "Nigeria", "Denmark"],
      controller: dropdownControllerCountry,
      title: "",
    ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField cityFormField(
  String hint,
) {
  final dropdownControllerCity = DropdownController(initialValue: "London");
  return CustomFormField(
    readOnly: true,
    suffix: DropdownWidget(
      options: ["London", "Abuja", "Accra"],
      controller: dropdownControllerCity,
      title: "",
    ),
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField bioFormField(String hint, TextEditingController controller) {
  return CustomFormField(
    maxLines: 3,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField nameofcertification(
    String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField timezoneField(String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField institution(String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField yearGraduated(String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}

CustomFormField modalities(String hint, TextEditingController controller) {
  return CustomFormField(
    verContentPadding: 12,
    horContentPadding: 12,
    hint: hint,
  );
}
