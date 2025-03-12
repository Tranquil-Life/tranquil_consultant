import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/properties.dart';
import 'package:tl_consultant/core/utils/services/validators.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

//email field
CustomFormField emailFormField(AuthController authController,
    {Function(String)? onChanged}){
  return CustomFormField(
    verContentPadding: 11.5,
    horContentPadding: 12,
    hint: 'enter email address',
    textEditingController: authController.emailTEC,
    textInputType: TextInputType.emailAddress,
    validator: (_)=>authController.signInValidation(),
    onChanged: onChanged ?? (_)=>
      authController.signInValidation(),
    // validator: (val) {
    //   if (val!.isEmpty) {
    //     return 'Please input your email';
    //   }
    //   if (!Validator.isEmail(val)) {
    //     return 'Please input a valid email address';
    //   }
    //
    //   return null;
    // },
  );
}

//Phone number field
IntlPhoneField phoneField(AuthController authController){
  return IntlPhoneField(
    initialValue: authController.params.phone,
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
          BorderSide(width: 1, color: ColorPalette.grey.shade900)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
          BorderSide(width: 1, color: ColorPalette.grey.shade900)),
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
      authController.params.phone = '${val.countryCode}$number';
    },
  );
}

//Password field
CustomFormField passwordField(AuthController authController){
  return CustomFormField(
    verContentPadding: 11.5,
    horContentPadding: 12,
    obscureText: !authController.isPasswordVisible.value,
    textInputType: TextInputType.visiblePassword,
    hint: 'Password',
    suffix: GestureDetector(
      onTap: (){
        authController.isPasswordVisible.value = !authController.isPasswordVisible.value;
      },
      child: authController.isPasswordVisible.value
          ? Icon(
        Icons.visibility,
        color: ColorPalette.green,
      )
          : const Icon(Icons.visibility_off),
    ),
    validator: (_) => authController.validatePassword(),
    onChanged: (text) {
      authController.params.password = text;
      authController.validatePassword();

      authController.signInValidation();

    },
  );
}

//Confirm password
CustomFormField confirmPwdField(AuthController authController){
  return CustomFormField(
    hint: 'Confirm Password',
    textEditingController: authController.confirmPasswordTEC,
    verContentPadding: 11.5,
    horContentPadding: 12,
    obscureText: !authController.isPasswordVisible.value,
    textInputType: TextInputType.visiblePassword,
    validator:(_)=> authController.validatePasswordMatch(),
    onChanged: (text) {
      authController.validatePasswordMatch();
    },
  );
}

//First name
CustomFormField firstNameField(){
  return CustomFormField(
    hint: 'First Name',
    // initialValue: AuthController.instance.params.firstName,
    textInputType: TextInputType.name,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    validator: (val) {
      if (val!.isEmpty) {
        return 'What is your first name?';
      }
      return null;
    },
    // onChanged: (text)=> AuthController.instance.params.firstName = text,
  );
}

//last name
CustomFormField lastNameField(){
  return CustomFormField(
    hint: 'Last Name',
    // initialValue: AuthController.instance.params.lastName,
    textInputType: TextInputType.name,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    validator: (val) {
      if (val!.isEmpty) {
        return 'What is your last name?';
      }
      return null;
    },
    // onChanged: (text)=> AuthController.instance.params.lastName = text,
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
    // onChanged: (text)=> AuthController.instance.params.birthDate = text,
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
      // if (AuthController.instance.params.cvUrl.isEmpty) return null;
      if (val!.isEmpty) return emptyCvField;
      return null;
    },
    // onChanged: (text)=>AuthController.instance.params.cvUrl = text,
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
      // if (AuthController.instance.params.identityUrl.isEmpty) return null;
      // if (val!.isEmpty) return emptyIdField;
      return null;
    },
    // onChanged: (text)=>AuthController.instance.params.identityUrl = text,
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
    // onChanged: (text)=> AuthController.instance.params.currentLocation = text

  );
}

//linkedin
CustomFormField linkedinField(){
  return CustomFormField(
    hint: 'LinkedIn profile URL',
    // initialValue: AuthController.instance.params.linkedinUrl,
    textInputType: TextInputType.text,
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.words,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Paste your LinkedIn profile URL';
      }
      return null;
    },
    // onChanged: (text)=> AuthController.instance.params.linkedinUrl = text,
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
      // if (AuthController.instance.params.expertise.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
    onChanged: (text){
      // AuthController.instance.params.expertise.clear();
      //
      // AuthController.instance.params.expertise.add(text);
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
      // if (AuthController.instance.params.yearsOfExperience.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
    onChanged: (text){
      // AuthController.instance.params.yearsOfExperience = text;
      // print("OnChanged:YEARS: ${AuthController.instance.params.yearsOfExperience}");
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
      // if (AuthController.instance.params.languages.isEmpty) return null;
      if (val!.isEmpty) return emptyIdField;
      return null;
    },
  );
}

