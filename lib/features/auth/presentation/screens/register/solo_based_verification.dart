import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';

class SoloBasedVerification extends StatefulWidget {
  const SoloBasedVerification({super.key});

  @override
  State<SoloBasedVerification> createState() => _SoloBasedVerificationState();
}

class _SoloBasedVerificationState extends State<SoloBasedVerification> {
  AuthController authController = Get.put(AuthController());
  VerificationController verificationController =
      Get.put(VerificationController());
  TextEditingController pinController = TextEditingController();
  int countdownSeconds = 60;
  Timer? timer;

  @override
  void initState() {
    pinController = TextEditingController();
    super.initState();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Get started',
        centerTitle: false,
        backgroundColor: ColorPalette.scaffoldColor,
      ),
      backgroundColor: ColorPalette.scaffoldColor,
      body: UnFocusWidget(
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the code",
                    style: TextStyle(
                      color: ColorPalette.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Enter the code sent to the email address ${authController.emailTEC.text} to proceed. Check your inbox or spam",
                    style: TextStyle(
                        fontSize: AppFonts.defaultSize,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.grey.shade500),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Enter code',
                    style: TextStyle(
                        color: ColorPalette.grey[600],
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    textStyle: TextStyle(color: ColorPalette.black),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 44,
                        fieldWidth: 45,
                        activeColor: verificationState() == false
                            ? ColorPalette.red
                            : ColorPalette.green,
                        inactiveColor: ColorPalette.grey[900],
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedColor: ColorPalette.green,
                        selectedFillColor: Colors.white,
                        errorBorderColor: ColorPalette.red),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    controller: pinController,
                    onCompleted: (v) {
                      verificationController.verifyAccount(pinController.text);
                      setState(() {});
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        verificationController.isVerified.value = false;
                        setState(() {});
                      }
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    appContext: context,
                  ),
                  if (verificationState() == false)
                    Text(
                      verifyFailedMsg,
                      style: TextStyle(color: ColorPalette.red, fontSize: 12),
                    ),
                  if (verificationState() == true)
                    Text(
                      verifySuccessMsg,
                      style: TextStyle(color: ColorPalette.green, fontSize: 12),
                    ),
                  if (verificationState() == false)
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: GestureDetector(
                                onTap: () {
                                  if (timer == null || !timer!.isActive) {
                                    startTimer();
                                    verificationController
                                        .requestVerificationToken(
                                            email: authController.emailTEC.text);
                                  }
                                },
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  direction: Axis.horizontal,
                                  children: [
                                    Text(
                                      (timer != null && timer!.isActive)
                                          ? 'Resend in'
                                          : 'Resend code',
                                      style: TextStyle(
                                          color: ColorPalette.green,
                                          fontSize: 16),
                                    ),
                                    if (timer != null && timer!.isActive)
                                      Text(
                                        " $countdownSeconds",
                                        style: TextStyle(
                                            color: ColorPalette.black,
                                            fontSize: 16),
                                      ),
                                  ],
                                )))),
                  Spacer(),
                  if (verificationState() == true)
                    CustomButton(
                        onPressed: () {
                          Get.toNamed(Routes.INTRODUCE_YOURSELF);
                        },
                        text: "Proceed to account creation"),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      //..
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
                  SizedBox(height: 40)
                ],
              )),
        ),
      ),
    );
  }

  verificationState() {
    if (verificationController.isConfirmed.value &&
        verificationController.isVerified.value) {
      return true;
    } else if (verificationController.isConfirmed.value &&
        !verificationController.isVerified.value) {
      return false;
    } else {
      return null;
    }
  }
}
