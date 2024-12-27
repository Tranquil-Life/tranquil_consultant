import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/theme/properties.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/app/presentation/widgets/dialogs.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/services/media_service.dart';
import 'package:tl_consultant/core/utils/services/validators.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

//email field
CustomFormField emailFormField(){
  return CustomFormField(
    verContentPadding: 11.5,
    horContentPadding: 12,
    hint: 'enter email address',
    textEditingController: AuthController.instance.emailTEC,
    textInputType: TextInputType.emailAddress,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Please input your email';
      }
      if (!Validator.isEmail(val)) {
        return 'Please input a valid email address';
      }

      return null;
    },
  );
}

//Phone number field
IntlPhoneField phoneField(){
  return IntlPhoneField(
    initialValue: AuthController.instance.params.phone,
    dropdownTextStyle: const TextStyle(color: ColorPalette.black),
    pickerDialogStyle: PickerDialogStyle(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 16),
    ),
    autovalidateMode: AutovalidateMode.disabled,
    dropdownIconPosition: IconPosition.trailing,
    flagsButtonPadding: const EdgeInsets.only(left: 12),
    // controller: controller,
    decoration: InputDecoration(
      counterStyle: const TextStyle(color: ColorPalette.white),
      hintText: 'Phone number',
      hintStyle: const TextStyle(
          fontSize: 18, color: Colors.grey),
      errorStyle: authScreensErrorStyle,
      border: InputBorder.none,
      fillColor: ColorPalette.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
          vertical: 11.5, horizontal: 12.0),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
          BorderSide(width: 1, color: ColorPalette.gray.shade900)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
          BorderSide(width: 1, color: ColorPalette.gray.shade900)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(width: 1, color: ColorPalette.red)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(width: 1, color: ColorPalette.red)),

    ),
    onChanged: (val) {
      var number = val.number.startsWith('0')
          ? val.number.substring(1)
          : val.number;
      AuthController.instance.params.phone = '${val.countryCode}$number';
    },
  );
}

//Password field
CustomFormField passwordField(){
  return CustomFormField(
    verContentPadding: 11.5,
    horContentPadding: 12,
    obscureText: !AuthController.instance.isPasswordVisible.value,
    textInputType: TextInputType.visiblePassword,
    textEditingController: AuthController.instance.passwordTEC,
    hint: 'Password',
    suffix: GestureDetector(
      onTap: (){
        AuthController.instance.isPasswordVisible.value = !AuthController.instance.isPasswordVisible.value;
      },
      child: AuthController.instance.isPasswordVisible.value
          ? Icon(
        Icons.visibility,
        color: ColorPalette.green,
      )
          : const Icon(Icons.visibility_off),
    ),
    validator: (val){
      if (val!.isEmpty) {
        return 'Please input a strong password';
      }
      if (val.length < 6) {
        return 'Your password should be at least 6 characters long';
      }
      return null;
    },
    //onChanged: (text)=> AuthController.instance.params.password = text,
  );
}

//Confirm password
CustomFormField confirmPwdField(){
  return CustomFormField(
    hint: 'Confirm Password',
    verContentPadding: 11.5,
    horContentPadding: 12,
    obscureText: !AuthController.instance.isPasswordVisible.value,
    textInputType: TextInputType.visiblePassword,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Please re-type your password';
      }
      if (AuthController.instance.passwordTEC.text != val) {
        return 'Your passwords do not match';
      }
      return null;
    },
  );
}

//First name
CustomFormField firstNameField(){
  return CustomFormField(
    hint: 'First Name',
    initialValue: AuthController.instance.params.firstName,
    textInputType: TextInputType.name,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    validator: (val) {
      if (val!.isEmpty) {
        return 'What is your first name?';
      }
      return null;
    },
    onChanged: (text)=> AuthController.instance.params.firstName = text,
  );
}

//last name
CustomFormField lastNameField(){
  return CustomFormField(
    hint: 'Last Name',
    initialValue: AuthController.instance.params.lastName,
    textInputType: TextInputType.name,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    validator: (val) {
      if (val!.isEmpty) {
        return 'What is your last name?';
      }
      return null;
    },
    onChanged: (text)=> AuthController.instance.params.lastName = text,
  );
}

//Date of birth
CustomFormField dateOfBirthField(){
  return CustomFormField(
    textEditingController: AuthController.instance.dateTEC,
    hint: 'Date of Birth',
    readOnly: true,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Your date of birth is required';
      }
      return null;
    },
    onChanged: (text)=> AuthController.instance.params.birthDate = text,
  );
}

//Attach a resumé
CustomFormField cvField({Function()? onTap}){
  return CustomFormField(
    textEditingController: AuthController.instance.cvTEC,
    hint: 'Upload your CV',
    textInputType: TextInputType.text,
    textCapitalization: TextCapitalization.words,
    readOnly: true,
    onTap: onTap,
    validator: (val) {
      if (AuthController.instance.params.cvUrl.isEmpty) return null;
      if (val!.isEmpty) return emptyCvField;
      return null;
    },
    onChanged: (text)=>AuthController.instance.params.cvUrl = text,
  );
}

//Attach ID
CustomFormField meansOfIdField({Function()? onTap}){
  return CustomFormField(
    textEditingController: AuthController.instance.identityTEC,
    hint: 'Upload a means of identification',
    textInputType: TextInputType.text,
    textCapitalization: TextCapitalization.words,
    readOnly: true,
    onTap: onTap,
    validator: (val) {
      if (AuthController.instance.params.identityUrl.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
    onChanged: (text)=>AuthController.instance.params.identityUrl = text,
  );
}

//current region
CustomFormField currentRegion(){
  return CustomFormField(
    hint: 'Country/region',
    textEditingController: AuthController.instance.currLocationTEC,
    textInputType: TextInputType.text,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    readOnly: true,
    validator: (val) {
      if (val!.isEmpty) {
        return 'What is your current location?';
      }
      return null;
    },
    onChanged: (text)=> AuthController.instance.params.currentLocation = text);
}

//linkedin
CustomFormField linkedinField(){
  return CustomFormField(
    hint: 'LinkedIn profile URL',
    initialValue: AuthController.instance.params.linkedinUrl,
    textInputType: TextInputType.text,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Paste your LinkedIn profile URL';
      }
      return null;
    },
    onChanged: (text)=> AuthController.instance.params.linkedinUrl = text,
  );
}

CustomFormField expertiseField({Function()? onTap}){
  return CustomFormField(
    hint: "Area of Expertise",
    textEditingController: AuthController.instance.areaOfExpertiseTEC,
    textInputType: TextInputType.text,
    readOnly: true,
    onTap: onTap,
    validator: (val) {
      if (AuthController.instance.params.expertise.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
    onChanged: (text){
      AuthController.instance.params.expertise.clear();

      AuthController.instance.params.expertise.add(text);
    },
  );
}

CustomFormField yearsOfExperienceField({Function()? onTap}){
  return CustomFormField(
    hint: "Years of Experience",
    textEditingController: AuthController.instance.yearsOfExperienceTEC,
    readOnly: true,
    onTap: onTap,
    validator: (val) {
      if (AuthController.instance.params.yearsOfExperience.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
    onChanged: (text){
      AuthController.instance.params.yearsOfExperience = text;
      print("OnChanged:YEARS: ${AuthController.instance.params.yearsOfExperience}");
    },
  );
}

CustomFormField pLanguageField({Function()? onTap}){
  return CustomFormField(
    hint: "Preferred Languages",
    textEditingController: AuthController.instance.languagesTEC,
    readOnly: true,
    onTap: onTap,
    validator: (val) {
      if (AuthController.instance.params.languages.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
  );
}

