import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_scaffold.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/therapist_type_screen.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/bg.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

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
                    color: ColorPalette.gray.shade500),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Email',
                style: TextStyle(color: ColorPalette.gray[600]),
              ),
              SizedBox(height: 8),
              emailFormField(authController),
              SizedBox(height: 16),
              Text(
                'Password',
                style: TextStyle(color: ColorPalette.gray[600]),
              ),
              SizedBox(height: 8),
              Obx(()=>passwordField(authController),),

              SizedBox(height: 16),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
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
        )
    );

    // return CustomBGWidget(
    //     title: 'Sign In',
    //     child: CustomScrollView(
    //         physics: const ClampingScrollPhysics(),
    //         slivers: [
    //           SliverToBoxAdapter(
    //             child: Column(
    //               children: [
    //                 const Padding(
    //                   padding: EdgeInsets.only(top: 32, bottom: 20),
    //                   child: Text(
    //                     'Welcome Back',
    //                     style: TextStyle(fontSize: 36),
    //                   ),
    //                 ),
    //
    //                 const Text(
    //                   'Sign In with your email and password',
    //                   style: TextStyle(fontSize: 18, height: 1.5),
    //                   textAlign: TextAlign.center,
    //                 ),
    //
    //                 Form(
    //                   key: _formKey,
    //                   child: Column(
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsets.symmetric(vertical: 12),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(8),
    //                           child: emailFormField(authController),
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.symmetric(vertical: 12),
    //                         child: Obx(()
    //                         => ClipRRect(
    //                           borderRadius: BorderRadius.circular(8),
    //                           child: passwordField(authController),
    //                         )),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //
    //                 Align(
    //                   alignment: Alignment.centerRight,
    //                   child: TextButton(
    //                     onPressed: () {
    //                       Get.to(ForgotPasswordPage());
    //                       // isModalOpen = true;
    //                       // showModalBottomSheet(
    //                       //   context: context,
    //                       //   backgroundColor: Colors.transparent,
    //                       //   builder: (_) => const ForgotPasswordBottomSheet(),
    //                       // ).then((value) => isModalOpen = false);
    //                     },
    //                     child: const Text(
    //                       'Forgot password',
    //                       style: TextStyle(
    //                         fontSize: 17,
    //                         color: ColorPalette.yellow,
    //                         fontWeight: FontWeight.normal,
    //                         decoration: TextDecoration.underline,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //
    //                 const SizedBox(height: 32),
    //                 CustomButton(
    //                     text: 'Sign In',
    //                     onPressed:()async{
    //                       //Get.toNamed(Routes.DASHBOARD);
    //                       await authController.signIn(
    //                         authController.emailTEC.text,
    //                         authController.confirmPasswordTEC.text,
    //                       );
    //                     }),
    //
    //               ],
    //             ),
    //           ),
    //
    //           SliverFillRemaining(
    //             hasScrollBody: false,
    //             child: Column(
    //               children: [
    //                 const Spacer(),
    //                 GestureDetector(
    //                   onTap: ()=> Get.to(()=>AccountTypeScreen()),
    //                   child: Align(
    //                     alignment: Alignment.center,
    //                     child: RichText(
    //                       text: TextSpan(
    //                         text: 'Don\'t have an account? ',
    //                         children: const [
    //                           TextSpan(
    //                             text: 'Sign up',
    //                             style: TextStyle(
    //                                 color: ColorPalette.yellow,
    //                                 fontSize: 16,
    //                                 fontFamily: AppFonts.josefinSansRegular),
    //                           ),
    //                         ],
    //                         style: TextStyle(color: ColorPalette.white, fontFamily: AppFonts.josefinSansRegular, fontSize: 16),
    //                       ),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //
    //                 const SizedBox(height: 8),
    //               ],
    //             ),
    //           ),
    //         ]
    //     )
    // );
  }
}
