import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_scaffold.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/password_criteria.dart';

class UpdatePasswordPage extends StatelessWidget {
  UpdatePasswordPage({super.key});

  final authController = Get.put(AuthController());
  final verificationController = Get.put(VerificationController());

  void _continue() async{
    if (authController.isAllPwdCriteriaMet) {
      var updated = await authController.updatePassword(
          token: verificationController.verificationToken.value,
          password: authController.params.password);

      if(updated){
        await Future.delayed(Duration(seconds: 2));

        Get.toNamed(Routes.SIGN_IN);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBarTitle: 'Create new password',
        content: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                "Now, all you have to do is create a new, unique password to regain access to your account",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.grey.shade500),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Password",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.black),
              ),
              Obx(() => passwordField(authController)),
              const SizedBox(
                height: 8,
              ),
              Obx(() => buildPasswordCriteria(authController)),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Re-enter password",
                style: const TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.black),
              ),
              const SizedBox(
                height: 8,
              ),
              confirmPwdField(authController),
              const SizedBox(
                height: 8,
              ),
              Obx(() => buildCriteriaRow(
                    "Must match password above",
                    authController.isPasswordsMatching.value,
                    initialColor: ColorPalette.grey.shade300,
                  )),
              Spacer(),
              Obx(() => CustomButton(
                  onPressed:
                      !authController.isAllPwdCriteriaMet ? null : _continue,
                  text: "Reset password")),
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
                        color: ColorPalette.grey.shade300,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
