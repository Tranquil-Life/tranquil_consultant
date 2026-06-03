import 'package:flutter/material.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/global/dropdownfield.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/label.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/noticebox.dart';

Widget professionalInfoPage(VerificationController verificationController, Function nextPage) {
  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Professional Information',
          style: TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w700,
            color: Color(0xff1F2937),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please enter your details below to start the verification process.',
          style: TextStyle(
            fontSize: 17,
            height: 1.45,
            color: Color(0xff6B7280),
          ),
        ),
        const SizedBox(height: 30),

        label('First name'),
        CustomFormField(
          verContentPadding: 11.5,
          horContentPadding: 12,
          hint: 'Enter your first name',
          textEditingController: verificationController.firstNameTEC,
          textInputType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          validator: (val) {
            if (val!.isEmpty) {
              return 'What is your first name?';
            }
            return null;
          },
        ),

        label('Last name'),
        CustomFormField(
          verContentPadding: 11.5,
          horContentPadding: 12,
          hint: 'Enter your last name',
          textEditingController: verificationController.lastNameTEC,
          textInputType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          validator: (val) {
            if (val!.isEmpty) {
              return 'What is your last name?';
            }
            return null;
          },
        ),

        label('Email address'),
        CustomFormField(
          verContentPadding: 11.5,
          horContentPadding: 12,
          hint: 'Enter email address',
          textEditingController: verificationController.emailTEC,
          textInputType: TextInputType.emailAddress,
          validator: (_) => verificationController.validateEmail(),
        ),

        label('Phone number'),
        TextField(
          controller: verificationController.phoneTEC,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: SizedBox(
              width: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('🇺🇸', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text('+1'),
                  // Icon(Icons.arrow_drop_down),
                  // VerticalDivider(width: 16),
                ],
              ),
            ),
            hintText: 'Enter your phone number',
            hintStyle: const TextStyle(color: Color(0xff9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff388D4D)),
            ),
          ),
        ),

        label('Profession'),
        dropdownField(
          value: verificationController.selectedProfession.value.isEmpty
              ? null
              : verificationController.selectedProfession.value,
          hint: 'Select your profession',
          items: professions,
          onChanged: (value) {
            verificationController.selectedProfession.value = value ?? '';
          },
        ),

        const SizedBox(height: 22),

        noticeBox(),

        const SizedBox(height: 30),

        CustomButton(onPressed: ()=> nextPage(), text: 'Continue'),
      ],
    ),
  );
}


