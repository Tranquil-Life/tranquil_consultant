import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/agency_based_verification.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/solo_based_verification.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/means_of_id_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final authController = AuthController.instance;
  final verificationController = VerificationController.instance;

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Get started',
          centerTitle: false,
          backgroundColor: ColorPalette.scaffoldColor,
        ),
        backgroundColor: ColorPalette.scaffoldColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter your details",
                    style: TextStyle(
                      color: ColorPalette.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Put your details in the form below to continue your registration",
                    style: TextStyle(
                        fontSize: AppFonts.defaultSize,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.grey.shade500),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Email',
                    style: TextStyle(color: ColorPalette.grey[600]),
                  ),
                  SizedBox(height: 8),
                  emailFormField(authController),
                  SizedBox(height: 12),
                  Text(
                    'Phone number',
                    style: TextStyle(color: ColorPalette.grey[600]),
                  ),
                  SizedBox(height: 8),
                  phoneField(authController),
                  Text(
                    'Password',
                    style: TextStyle(color: ColorPalette.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Obx(() => passwordField(authController)),
                  SizedBox(height: 12),
                  Text(
                    'Confirm password',
                    style: TextStyle(color: ColorPalette.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Obx(() => confirmPwdField(authController)),
                  SizedBox(
                    height: displayHeight(context) / 10,
                  ),
                  Obx(() => CustomButton(
                        onPressed: () async {
                          if (authController.selectedType.value == solo) {
                            var sent = await verificationController
                                .requestVerificationToken(
                                    email: authController.emailTEC.text);

                            if (sent) {
                              Get.to(SoloBasedVerification());
                            }
                          } else {
                            Get.to(AgencyBasedVerification());
                          }
                        },
                        child: verificationController.requesting.value
                            ? CircularProgressIndicator(
                                color: ColorPalette.white)
                            : Text(
                                "Continue",
                                style: TextStyle(color: ColorPalette.white),
                              ),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      //To Sign in page
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'I have an account. ',
                          children: const [
                            TextSpan(
                              text: 'Sign me in...',
                              style: TextStyle(
                                  color: ColorPalette.green,
                                  fontFamily: AppFonts.josefinSansRegular),
                            ),
                          ],
                          style: TextStyle(
                              color: ColorPalette.grey.shade300,
                              fontFamily: AppFonts.josefinSansRegular),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
