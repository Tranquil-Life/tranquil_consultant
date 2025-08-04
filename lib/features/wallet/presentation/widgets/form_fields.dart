import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

CustomFormField amountField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.amountTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    readOnly: !earningsController.payoutExists() ? true : false,
    hintColor: ColorPalette.grey.shade800,
    prefix: Text(
      "\$ ",
      style: TextStyle(color: ColorPalette.grey[600]),
    ),
    onTap: () {
      if (!earningsController.payoutExists()) {
        Get.dialog(AlertDialog(
          title: Text("You don't have a payout account"),
          content: Text.rich(
            TextSpan(
              text:
                  'Fill in all the empty fields, then tick the checkbox that says ',
              style: TextStyle(color: Colors.black), // your base style
              children: [
                TextSpan(
                  text: 'save details for later',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
      }
    },
  );
}

CustomFormField beneficiaryNameField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.beneficiaryNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter full name",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.keyboard_arrow_right),
    ),
  );
}

CustomFormField beneficiaryEmailField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.beneficiaryEmailTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter email address",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField beneficiaryDOBField(EarningsController earningsController,
    List<TextInputFormatter>? inputFormatter) {
  return CustomFormField(
      textEditingController: earningsController.dobTEC,
      verContentPadding: 12,
      horContentPadding: 12,
      hint: "enter date of birth",
      hintColor: ColorPalette.grey.shade800,
      inputFormatter: inputFormatter);
}

CustomFormField beneficiaryFirstNameField(
    EarningsController earningsController, Function(String)? onChanged) {
  return CustomFormField(
    textEditingController: earningsController.beneficiaryFirstNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter beneficiary first name",
    hintColor: ColorPalette.grey.shade800,
    onChanged: onChanged,
  );
}

CustomFormField beneficiaryLastNameField(
    EarningsController earningsController, Function(String)? onChanged) {
  return CustomFormField(
    textEditingController: earningsController.beneficiaryLastNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter beneficiary last name",
    hintColor: ColorPalette.grey.shade800,
    onChanged: onChanged,
  );
}

CustomFormField beneficiaryAddressField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.beneficiaryAddressTEC,
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
    readOnly: true,
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

CustomFormField ibanField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.ibanTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter your iban",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField swiftCodeField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.swiftCodeTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter your iban",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField recipientCountryField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.recipientCountryTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter recipient country",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: Icon(earningsController.isCountryDropdownVisible.value
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField recipientStateField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.recipientStateTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter recipient state",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: Icon(earningsController.isStateDropdownVisible.value
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField recipientCityField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.recipientCityTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter recipient city",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: Icon(earningsController.isCityDropdownVisible.value
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down),    ),
  );
}

CustomFormField bankCountryField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.bankCountryTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter bank country",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: Icon(earningsController.isCountryDropdownVisible.value
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField bankStateField(
    EarningsController earningsController, Function()? onTap) {
  return CustomFormField(
    readOnly: true,
    textEditingController: earningsController.bankStateTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter bank state",
    hintColor: ColorPalette.grey.shade800,
    suffix: GestureDetector(
      onTap: onTap,
      child: Icon(earningsController.isStateDropdownVisible.value
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down),
    ),
  );
}

CustomFormField streetField(EarningsController earningsController) {
  final dashboardController = DashboardController.instance;
  return CustomFormField(
    textEditingController: earningsController.recipientStreetTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: dashboardController.street.value,
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField aptNumberField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.recipientAptNoTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter apartment number",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField postalCodeField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.postalCodeTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter postal code",
    hintColor: ColorPalette.grey.shade800,
  );
}

// CustomFormField beneficiaryPhoneField(EarningsController earningsController) {
//   return CustomFormField(
//     textEditingController: earningsController.beneficiaryPhoneTEC,
//     verContentPadding: 12,
//     horContentPadding: 12,
//     hint: "enter phone number",
//     hintColor: ColorPalette.grey.shade800,
//     prefix: ,
//   );
// }

IntlPhoneField beneficiaryPhoneField(EarningsController earningsController) {
  return IntlPhoneField(
    controller: earningsController.beneficiaryPhoneTEC,
    // initialValue: authController.params.phone,
    dropdownTextStyle: const TextStyle(color: ColorPalette.black),
    pickerDialogStyle: PickerDialogStyle(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    ),
    autovalidateMode: AutovalidateMode.disabled,
    dropdownIconPosition: IconPosition.trailing,
    flagsButtonPadding: const EdgeInsets.only(left: 12),
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    // controller: controller,
    decoration: InputDecoration(
      counterStyle: const TextStyle(color: ColorPalette.white),
      hintText: 'enter phone number',
      hintStyle: TextStyle(color: ColorPalette.grey.shade800, fontSize: 14),
      // errorStyle: authScreensErrorStyle,
      border: InputBorder.none,
      fillColor: ColorPalette.white,
      filled: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 11.5, horizontal: 12.0),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 1, color: ColorPalette.grey.shade900)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 1, color: ColorPalette.grey.shade900)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(width: 1, color: ColorPalette.red)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(width: 1, color: ColorPalette.red)),
    ),
    onChanged: (val) {
      earningsController.phoneNumber.value = '${val.countryCode}${val.number}';
      print(earningsController.phoneNumber.value);
    },
  );
}

CustomFormField accountNumberField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.accountNumberTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter account number",
    hintColor: ColorPalette.grey.shade800,
    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
  );
}

CustomFormField routingNumberField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.routingNumberTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter routing number",
    hintColor: ColorPalette.grey.shade800,
    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
  );
}

CustomFormField holderNameField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.accountHolderNameTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter holder's name",
    hintColor: ColorPalette.grey.shade800,
  );
}

CustomFormField ssnField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.ssnTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "enter SSN (Social security number)",
    hintColor: ColorPalette.grey.shade800,
    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
  );
}

CustomFormField websiteField(EarningsController earningsController) {
  return CustomFormField(
    textEditingController: earningsController.businessWebsiteTEC,
    verContentPadding: 12,
    horContentPadding: 12,
    hint: "Enter business website (if any)",
    hintColor: ColorPalette.grey.shade800,
  );
}

