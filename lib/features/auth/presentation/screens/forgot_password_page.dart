import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_form_field.dart';
import 'package:tl_consultant/core/global/custom_scaffold.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/services/validators.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final authController = Get.put(AuthController());
  final verificationController = Get.put(VerificationController());

  String error = '';

  void _continue() async{
    if (Validator.isEmail(authController.emailTEC.text)) {
      setState(() => error = '');
      var sent = await verificationController.requestPwdResetToken(
          email: authController.emailTEC.text);
      if(sent){
        Get.toNamed(Routes.VERIFY_RESET_ACCOUNT);
      }
    } else {
      setState(() => error = 'Please input a valid email address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBarTitle: 'Forgot password',
        content: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                "Don’t worry. This has happened to us too. Enter the email address you created your account with to get a reset code",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.gray.shade500),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Email",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.black),
              ),
              const SizedBox(
                height: 8,
              ),
              emailFormField(authController, onChanged: (_){
                setState(() {});
              }),
              Text(
                error,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.red),
              ),
              Spacer(),
              CustomButton(
                  onPressed:
                      authController.emailTEC.text.isEmpty ? null : _continue,
                  text: "Send to email"),
              SizedBox(height: 44),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.SIGN_IN);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'I have an account. ',
                      children: const [
                        TextSpan(
                          text: 'Sign me in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ColorPalette.green,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: ColorPalette.gray.shade300,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ])));
  }
}
