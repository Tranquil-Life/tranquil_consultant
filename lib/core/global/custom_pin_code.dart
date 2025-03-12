import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

// ignore: must_be_immutable
class CustomPinCodeWidget extends StatelessWidget {
  final TextEditingController pinController;
  FocusNode? focusNode;
  // final int pinLength;
  final PinTheme? customPinTheme;
  final MainAxisAlignment? mainAxisAlignment;

  CustomPinCodeWidget(
      {super.key,
      this.mainAxisAlignment,
      this.onCompleted,
      // this.pinLength = 4,
      this.customPinTheme,
      required this.pinController});

  final Function(String)? onCompleted;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: displayWidth(context),
      child: PinCodeTextField(
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.blue.shade50,
        enableActiveFill: true,
        // errorAnimationController: errorController,
        controller: pinController,
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
          // setState(() {
          //   currentText = value;
          // });
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
        appContext: context,
      ),
    );
  }
}
