import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/dropdownfield.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/auth/data/models/therapist_application_model.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/label.dart';

Widget licenseInfoPage(VerificationController verificationController,
    Function nextPage) {
  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'License Information',
          style: TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w700,
            color: Color(0xff1F2937),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Add your license details so we can verify your eligibility.',
          style: TextStyle(
            fontSize: 17,
            height: 1.45,
            color: Color(0xff6B7280),
          ),
        ),
        const SizedBox(height: 30),
        label('Home state license'),
        dropdownField(
          value: verificationController.selectedState.value.isEmpty
              ? null
              : verificationController.selectedState.value,
          hint: 'Select state',
          items: states,
          onChanged: (value) {
            verificationController.selectedState.value = value ?? '';
          },
        ),
        label('License number'),
        CustomFormField(
          verContentPadding: 11.5,
          horContentPadding: 12,
          hint: 'Enter your license number',
          textEditingController: verificationController.licenseNumberController,
          textInputType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Enter your license number';
            }
            return null;
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 6, bottom: 16),
          child: Text(
            'Example: TX LPC #12345',
            style: TextStyle(
              color: Color(0xff6B7280),
              fontSize: 14,
            ),
          ),
        ),
        label('NPI number (optional)'),
        CustomFormField(
          verContentPadding: 11.5,
          horContentPadding: 12,
          hint: 'Enter your NPI number',
          textEditingController: verificationController.npiController,
          textInputType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Enter your NPI number';
            }
            return null;
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 6, bottom: 22),
          child: Text(
            'If available, providing your NPI may help speed up the verification process.',
            style: TextStyle(
              color: Color(0xff6B7280),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
        const Text(
          'Additional licenses (optional)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xff111827),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => verificationController.addLicense(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffD1D5DB),
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text(
                '+  Add another license',
                style: TextStyle(
                  color: ColorPalette.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () =>
              Column(
                children: List.generate(
                  verificationController.additionalLicenses.length,
                      (index) {
                    final license =
                    verificationController.additionalLicenses[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffD1D5DB),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'License ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () =>
                                    verificationController.removeLicense(index),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          dropdownField(
                            value: license.state,
                            hint: 'Select state',
                            items: states,
                            onChanged: (value) {
                              license.state = value!;
                              verificationController.additionalLicenses
                                  .refresh();
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomFormField(
                            hint: 'License number',
                            initialValue: license.licenseNumber,
                            textInputType: TextInputType.text,
                            onChanged: (value) {
                              license.licenseNumber = value;
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        ),
        const SizedBox(height: 30),
        CustomButton(
            onPressed: () async{
              final application = TherapistApplication(
                firstName: verificationController.firstNameTEC.text.trim(),
                lastName: verificationController.lastNameTEC.text.trim(),
                email: verificationController.emailTEC.text.trim(),
                phone: verificationController.phoneTEC.text.trim(),
                profession: verificationController.selectedProfession.value,
                homeStateLicense: verificationController.selectedState.value,
                licenseNumber: verificationController.licenseNumberController.text.trim(),
                npiNumber: verificationController.npiController.text.trim(),
                additionalLicenses: verificationController.additionalLicenses.toList(),
              );

              await verificationController.createApplication(application);
            },
            text: 'Submit for Verification'),
      ],
    ),
  );
}
