import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_scaffold.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/therapist_type_screen.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authController = Get.put(AuthController());

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPasswordVisible = true, isModalOpen = false;
  String email = '', password = '';

  bool get criteriaMet=> authController.emailIsValid.value && authController.passwordIsValid.value;

  _continue() async{
    if(criteriaMet){
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
              Text(
                "Log back into your account to continue enjoying your personalized resources",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.grey.shade500),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Email',
                style: TextStyle(color: ColorPalette.grey[600]),
              ),
              SizedBox(height: 8),
              emailFormField(authController),
              SizedBox(height: 16),
              Text(
                'Password',
                style: TextStyle(color: ColorPalette.grey[600]),
              ),
              SizedBox(height: 8),
              Obx(()=>passwordField(authController)),

              SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () async{
                      Get.toNamed(Routes.FORGOT_PASSWORD);
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: ColorPalette.green[800],
                        fontSize: AppFonts.defaultSize,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),

              Spacer(),

              Obx(()=>CustomButton(
                  onPressed: !criteriaMet
                      ? null
                      : _continue, text: "Sign In")),

              SizedBox(height: 44),

              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: ()=> Get.to(()=>AccountTypeScreen()),
                  child: RichText(
                    text: TextSpan(
                      text: 'I don’t have an account. ',
                      children: const [
                        TextSpan(
                          text: 'Create one',
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
        )
    );

  }
}
