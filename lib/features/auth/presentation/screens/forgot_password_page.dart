import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/services/validators.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final authController = Get.put(AuthController());

  String error = '';

  void _continue() {
    if (Validator.isEmail(authController.emailTEC.text)) {
      setState(() => error = '');
      Get.toNamed(Routes.VERIFY_RESET_ACCOUNT);
    } else {
      setState(() => error = 'Please input a valid email address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorPalette.scaffoldColor,
        appBar: CustomAppBar(
          title: 'Forgot password',
          centerTitle: false,
          onBackPressed: () => Get.back(),
        ),
        body: SafeArea(
            child: SizedBox(
              child: Stack(
                children: [
                  Positioned(
                    bottom: displayHeight(context) / 30,
                    // Shifts the image to the bottom
                    right: 0,
                    // Shifts the image to the right
                    child: SvgPicture.asset(
                      SvgElements.svgPlantImage,
                      width: 400, // Adjust size as needed
                      height: 350, // Adjust size as needed
                      fit: BoxFit.contain, // Ensure proportions are maintained
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            CustomFormField(
                              textEditingController: authController.emailTEC,
                              hint: "example@gmail.com",
                              verContentPadding: 16,
                              horContentPadding: 16,
                            ),
                            Text(
                              error,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorPalette.red),
                            ),
                            const SizedBox(
                              height: 16,
                            ),

                            Spacer(),

                            CustomButton(
                                onPressed: authController.emailTEC.text.isEmpty
                                    ? null
                                    : _continue, text: "Send to email"),

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
                          ])),
                ],
              ),
            )),
      ),
    );
  }
}
