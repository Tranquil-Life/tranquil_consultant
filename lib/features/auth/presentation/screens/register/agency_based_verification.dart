import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_pin_code.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/introduce_yourself.dart';

class AgencyBasedVerification extends StatefulWidget {
  const AgencyBasedVerification({super.key});

  @override
  State<AgencyBasedVerification> createState() =>
      _AgencyBasedVerificationState();
}

class _AgencyBasedVerificationState extends State<AgencyBasedVerification> {
  VerificationController verificationController =
      Get.put(VerificationController());
  final pinController = TextEditingController();

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
          child: Obx(()=>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                verifyIdentityTitle,
                style: TextStyle(
                  color: ColorPalette.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                agencyVerifyIdentityMsg,
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.gray.shade500),
              ),
              SizedBox(height: 40),
              Text(
                'Enter code',
                style: TextStyle(
                    color: ColorPalette.gray[600], fontWeight: FontWeight.w600),
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
                    inactiveColor: ColorPalette.gray[900],
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
                Padding(padding: EdgeInsets.only(bottom: 24), child: Text(
                  verifyFailedMsg,
                  style: TextStyle(color: ColorPalette.red, fontSize: 12),
                )),
              if (verificationState() == false)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      contactAgencyForCodeMsg,
                      style: TextStyle(color: ColorPalette.black, fontSize: 12),
                    ),
                    Text(
                      "contact@tranquillife.app",
                      style: TextStyle(color: ColorPalette.blue, fontSize: 12),
                    ),
                  ],
                ),
              if (verificationState() == false)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: GestureDetector(
                      onTap: (){
                        pinController.clear();
                      },
                      child: Text("Try again", style: TextStyle(color: ColorPalette.green, fontSize: 16),),
                    ),
                  ),
                ),
              if (verificationState() == true)
                Text(
                  verifySuccessMsg,
                  style: TextStyle(color: ColorPalette.green, fontSize: 12),
                ),

              Spacer(),
              if (verificationState() == true)
                CustomButton(
                    onPressed: () {
                      Get.to(IntroduceYourselfPage());
                    },
                    text: "Proceed to sign up"),

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
                          color: ColorPalette.gray.shade300,
                          fontFamily: AppFonts.josefinSansRegular),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 40)
            ],
          )),
        )),
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
