import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_scaffold.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/password_criteria.dart';

class UpdatePasswordPage extends StatelessWidget {
  UpdatePasswordPage({super.key});

  final authController = Get.put(AuthController());

  void _continue() {
    if (authController.isAllCriteriaMet) {
      Get.offAllNamed(Routes.SIGN_IN);
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
                    color: ColorPalette.gray.shade500),
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
              passwordField(authController),
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
              Obx(()=>buildCriteriaRow(
                "Must match password above",
                authController.isPasswordsMatching.value,
                initialColor: ColorPalette.gray.shade300,
              )),
              Spacer(),

              Obx(()=>CustomButton(
                  onPressed: !authController.isAllCriteriaMet
                      ? null
                      : _continue, text: "Reset password")),

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
            ],
          ),
        ));
  }
}
