import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/bg.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

class SignUpScreen0 extends StatefulWidget {
  const SignUpScreen0({super.key});

  @override
  State<SignUpScreen0> createState() => _SignUpScreen0State();
}

class _SignUpScreen0State extends State<SignUpScreen0> {
  final authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();
  final termsOfServiceGS = TapGestureRecognizer();
  final privacyPolicyGS = TapGestureRecognizer();

  @override
  void initState() {
    termsOfServiceGS.onTap = () {
      print("Terms of service");
    };
    privacyPolicyGS.onTap = () {
      print("Privacy policy");
    };

    super.initState();
  }

  @override
  void dispose() {
    termsOfServiceGS.dispose();
    privacyPolicyGS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBGWidget(
        title: 'Sign Up',
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 32, bottom: 20),
                child: Text(
                  'Register Account',
                  style: TextStyle(
                      fontSize: AppFonts.defaultSize*2,
                      fontFamily: AppFonts.josefinSansSemiBold
                  ),
                ),
              ),

              const Text(
                'Input your details',
                style: TextStyle(fontSize: AppFonts.defaultSize),
              ),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //email field
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: emailFormField(authController),
                        )
                    ),

                    const SizedBox(height: 12),

                    //Phone number field
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: phoneField(authController),
                    ),

                    //Password field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Obx(()
                      => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: passwordField(authController),
                      )),
                    ),

                    //Confirm password
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: confirmPwdField(authController),
                        )
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              CustomButton(
                text: "Next",
                onPressed: () {
                  // SchedulerBinding.instance.addPostFrameCallback((_) {
                  //   if (_formKey.currentState!.validate()) {
                  //     Get.toNamed(Routes.SIGN_UP_1);
                  //   }
                  // });
                  Get.toNamed(Routes.SIGN_UP_1);

                },),

              const SizedBox(height: 64),

              //privacy policy and agreement
              RichText(
                text: TextSpan(
                  text:
                  'By clicking "Next", you are indicating that you have read and agreed to the ',
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      recognizer: termsOfServiceGS,
                      style: const TextStyle(
                        fontSize: 16,
                        color: ColorPalette.yellow,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      recognizer: privacyPolicyGS,
                      style: const TextStyle(
                        fontSize: 16,
                        color: ColorPalette.yellow,
                      ),
                    ),
                  ],
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),
            ],
          ),
        )
    );
  }
}
