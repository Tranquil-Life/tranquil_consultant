import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_scaffold.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';

class VerifyResetAccountPage extends StatefulWidget {
  const VerifyResetAccountPage({super.key});

  @override
  State<VerifyResetAccountPage> createState() => _VerifyResetAccountPageState();
}

class _VerifyResetAccountPageState extends State<VerifyResetAccountPage> {
  final authController = Get.put(AuthController());
  final verificationController = Get.put(VerificationController());
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
    return CustomScaffold(
        appBarTitle: 'Verify account',
        content: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Obx(() =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Enter the security code sent to ${authController.emailTEC.text} to verify your account. Check your inbox or spam",
                    style: TextStyle(
                        fontSize: isSmallScreen(context)
                            ? AppFonts.defaultSize
                            : AppFonts.baseSize,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.grey.shade500),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // const Text(
                  //   "Email",
                  //   style: TextStyle(
                  //       fontSize: AppFonts.defaultSize,
                  //       fontWeight: FontWeight.w400,
                  //       color: ColorPalette.black),
                  // ),
                  const SizedBox(
                    height: 8,
                  ),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    textStyle: TextStyle(
                        color: ColorPalette.black,
                        fontSize:
                            isSmallScreen(context) ? AppFonts.defaultSize : 24),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: isSmallScreen(context) ? 44 : 84,
                        fieldWidth: isSmallScreen(context) ? 45 : 85,
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
                      verificationController
                          .verifyResetToken(pinController.text);
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
                      style: TextStyle(
                        color: ColorPalette.red,
                        fontSize: isSmallScreen(context)
                            ? AppFonts.defaultSize
                            : AppFonts.baseSize,
                      ),
                    ),
                  if (verificationState() == true)
                    Text(
                      verifySuccessMsg,
                      style: TextStyle(
                        color: ColorPalette.green,
                        fontSize: isSmallScreen(context)
                            ? AppFonts.defaultSize
                            : AppFonts.baseSize,
                      ),
                    ),
                  if (verificationState() == false)
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: GestureDetector(
                                onTap: () async {
                                  if (timer == null || !timer!.isActive) {
                                    startTimer();
                                    var sent = await verificationController
                                        .requestPwdResetToken(
                                            email:
                                                authController.emailTEC.text);
                                    if (sent) {
                                      Get.toNamed(Routes.VERIFY_RESET_ACCOUNT);
                                    }
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
                    Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: isSmallScreen(context) ? displayWidth(context) : displayWidth(context) /1.4),
                        child: CustomButton(
                          onPressed: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                          text: "Proceed",
                        ),
                      ),
                    ),
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
                          children: [
                            TextSpan(
                              text: 'Sign me in...',
                              style: TextStyle(
                                  color: ColorPalette.green,
                                  fontFamily: AppFonts.mulishBold,
                                fontSize: isSmallScreen(context) ? AppFonts.defaultSize : AppFonts.baseSize,

                              ),
                            ),
                          ],
                          style: TextStyle(
                              color: ColorPalette.grey.shade300,
                              fontFamily: AppFonts.mulishRegular,
                            fontSize: isSmallScreen(context) ? AppFonts.defaultSize : AppFonts.baseSize,

                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]))));
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
