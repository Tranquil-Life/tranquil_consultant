import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({Key? key}) : super(key: key);

  @override
  State<SignUpScreen3> createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUpScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        centerTitle: false,
        title: "Create your account",
        titleColor: ColorPalette.black,
        hideBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Introduce yourself",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const Text(
                "Record a 1 minute audio and video of yourself",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                  height: 510), // Add some space between text and button
              CustomButton(
                text: 'Complete sign up',
                onPressed: () {
                  Get.toNamed(Routes.SIGN_UP_4);
                  // if (_formKey.currentState!.validate()) {
                  //   authController.signUp();
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
