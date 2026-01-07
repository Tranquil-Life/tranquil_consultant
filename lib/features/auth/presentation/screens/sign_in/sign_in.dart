import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_scaffold.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/therapist_type_screen.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authController = AuthController.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPasswordVisible = true, isModalOpen = false;
  String email = '', password = '';

  bool get criteriaMet =>
      authController.emailIsValid.value && authController.passwordIsValid.value;

  Future<void> _continue() async {
    if (criteriaMet) {
      await authController.signIn(
        authController.emailTEC.text,
        authController.params.password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        key: _scaffoldKey,
        appBarTitle: 'Sign in to your account',
        hideBackButton: true,
        centerTitle: true,
        content: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              // Text(
              //   "Log back into your account to continue enjoying your personalized resources",
              //   style: TextStyle(
              //       fontSize: isSmallScreen(context) ? AppFonts.defaultSize : AppFonts.baseSize,
              //       fontWeight: FontWeight.w400,
              //       color: ColorPalette.grey.shade500),
              // ),
              // const SizedBox(
              //   height: 25,
              // ),
              CustomText(
                text: 'Email',
                color: ColorPalette.grey[600],
                size: isSmallScreen(context)
                    ? AppFonts.defaultSize
                    : AppFonts.baseSize,
              ),
              SizedBox(height: 8),
              emailFormField(authController),
              SizedBox(height: 16),
              CustomText(
                text: 'Password',
                color: ColorPalette.grey[600],
                size: isSmallScreen(context)
                    ? AppFonts.defaultSize
                    : AppFonts.baseSize,
              ),
              SizedBox(height: 8),
              Obx(() => passwordField(authController)),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () async {
                      Get.toNamed(Routes.FORGOT_PASSWORD);
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: ColorPalette.green[800],
                        fontSize: isSmallScreen(context)
                            ? AppFonts.defaultSize
                            : AppFonts.baseSize,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),

              GestureDetector(
                onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("hello")),
                  );

                  print("sing in");
                  // CustomSnackBar.showSnackBar(context: context, message: "hello", backgroundColor: Colors.green);
                },
                child: Text("hello", style: TextStyle(color: Colors.blue),),
              ),
              // Spacer(),


              // Obx(
              //   () => Align(
              //     alignment: Alignment.center,
              //     child: ConstrainedBox(
              //         constraints: BoxConstraints(
              //             maxWidth: isSmallScreen(context)
              //                 ? displayWidth(context)
              //                 : displayWidth(context) / 1.4),
              //         child: CustomButton(
              //             onPressed: !criteriaMet ? null : _continue,
              //             text: "Sign In")),
              //   ),
              // ),

              // CustomButton(
              //     onPressed: (){
              //       CustomSnackBar.successSnackBar(body: "SIGN IN", title: "Clicked" );
              //     },
              //     text: "Sign In"),
              SizedBox(height: 44),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => Get.to(() => AccountTypeScreen()),
                  child: RichText(
                    text: TextSpan(
                      text: 'I don’t have an account. ',
                      children: [
                        TextSpan(
                          text: 'Create one',
                          style: TextStyle(
                            fontSize:
                                isSmallScreen(context) ? AppFonts.baseSize : 18,
                            fontWeight: FontWeight.w400,
                            color: ColorPalette.green,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: ColorPalette.grey.shade300,
                        fontSize:
                            isSmallScreen(context) ? AppFonts.baseSize : 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 40)
            ],
          ),
        ));
  }
}
