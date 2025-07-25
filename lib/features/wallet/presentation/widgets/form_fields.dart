import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

CustomFormField amountField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.amountTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hintColor: ColorPalette.grey.shade800,
    prefix: Text(
      "\$ ",
      style: TextStyle(color: ColorPalette.grey[600]),
    ),
  );
}

CustomFormField beneficiaryNameField(
    EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.beneficiaryNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter beneficiary name",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField beneficiaryAddressField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.beneficiaryNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter beneficiary address",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_right),
    ),
  );
}

CustomFormField bankNameField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    textEditingController: earningsController.bankNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "select your bank",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_right),
    ),
  );
}

CustomFormField bankAddressField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    textEditingController: earningsController.bankAddressTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter bank address",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_right),
    ),
  );
}

CustomFormField ibanField(
    EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.ibanTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter your iban",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField swiftCodeField(
    EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.swiftCodeTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter your iban",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField countryField(
    EarningsController earningsController, Function()? onTap) {
  final dashboardController = DashboardController.instance;
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.recipientCountryTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter recipient country",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField stateField(
    EarningsController earningsController, Function()? onTap) {
  final dashboardController = DashboardController.instance;
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.recipientStateTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter recipient state",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField cityField(
    EarningsController earningsController, Function()? onTap) {
  final dashboardController = DashboardController.instance;
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.recipientCityTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter recipient city",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField streetField(
    EarningsController earningsController) {
  final dashboardController = DashboardController.instance;
  return CustomFormField(
    textEditingController: earningsController.recipientStreetTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: dashboardController.street.value,
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField aptNumberField(
    EarningsController earningsController) {
  final dashboardController = DashboardController.instance;
  return CustomFormField(
    textEditingController: earningsController.recipientAptNoTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter apartment number",
    hintColor: ColorPalette.grey.shade800,
  );
}
