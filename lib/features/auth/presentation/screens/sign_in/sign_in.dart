import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/bg.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/forgot_password.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = 'sign_in_screen';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = true, isModalOpen = false;
  String email = '', password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBGWidget(
        title: 'Sign In',
        child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 32, bottom: 20),
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(fontSize: 36),
                      ),
                    ),

                    const Text(
                      'Sign In with your email and password',
                      style: TextStyle(fontSize: 18, height: 1.5),
                      textAlign: TextAlign.center,
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: emailFormField(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Obx(()
                            => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: passwordField(),
                            )),
                          ),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          isModalOpen = true;
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const ForgotPasswordBottomSheet(),
                          ).then((value) => isModalOpen = false);
                        },
                        child: const Text(
                          'Forgot password',
                          style: TextStyle(
                            fontSize: 17,
                            color: ColorPalette.yellow,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    CustomButton(
                        text: 'Sign In',
                        onPressed:()async{
                          await authController.signIn(
                            authController.emailTEC.text,
                            authController.passwordTEC.text,
                          );

                          // if(userDataStore.user!.authToken!.isNotEmpty){
                          //   Get.offAllNamed(Routes.DASHBOARD);
                          // }
                        }),

                  ],
                ),
              ),

              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    MyDefaultTextStyle(
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      child: GestureDetector(
                        onTap: ()=>Get.toNamed(Routes.SIGN_UP_0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Don't have an account?"),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.SIGN_UP_0),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(color: ColorPalette.yellow),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ]
        )
    );
  }
}