import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final authController = AuthController.instance;
  final verificationController = VerificationController.instance;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final tokenController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String password = '';
  String confirmPassword = '';

  bool get hasMinLength => password.length >= 6;

  bool get hasNumber => RegExp(r'\d').hasMatch(password);

  bool get hasLetter => RegExp(r'[A-Za-z]').hasMatch(password);

  bool get hasSpecial =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=]').hasMatch(password);

  bool get passwordsMatch =>
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword;

  bool get canActivate =>
      hasMinLength && hasNumber && hasLetter && hasSpecial && passwordsMatch;

  bool tokenValidated = false;

  Future<void> validateEnteredToken() async {
    final enteredToken = tokenController.text.trim();

    if (enteredToken.isEmpty) {
      verificationController.errorMessage.value =
          'Please enter your invitation code.';
      return;
    }

    verificationController.verificationToken.value = enteredToken;

    final valid =
        await verificationController.validateInvitationToken(enteredToken);

    if (valid) {
      setState(() {
        tokenValidated = true;
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 700;
    if (!tokenValidated) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 650 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verify invitation',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter the invitation code sent to your email to continue setting up your Tranquil Life Pro account.',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: Color(0xff6B7280),
                      ),
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      controller: tokenController,
                      decoration: InputDecoration(
                        hintText: 'Enter invitation code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: validateEnteredToken,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Validate Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Get.toNamed(Routes.SIGN_IN);
                        },
                        child: const Text(
                          'I have an account. Sign me in...',
                          style: TextStyle(
                            color: ColorPalette.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 650 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Obx(() => RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Congratulations!',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1F2937),
                              ),
                            ),
                            // TextSpan(
                            //   text:
                            //       '${verificationController.firstName.value}!',
                            //   style: TextStyle(
                            //     fontSize: 36,
                            //     fontWeight: FontWeight.w700,
                            //     color: ColorPalette.green,
                            //   ),
                            // ),
                            TextSpan(
                              text: ' 🎊',
                              style: TextStyle(
                                fontSize: 36,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  const Text(
                    'Your application has been approved.\nSet a password to activate your Tranquil Life Pro account.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Color(0xff6B7280),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: ColorPalette.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  passwordRequirement(
                    'Must be at least 6 characters',
                    hasMinLength,
                  ),
                  passwordRequirement(
                    'Must contain at least one number',
                    hasNumber,
                  ),
                  passwordRequirement(
                    'Must contain at least one special character',
                    hasSpecial,
                  ),
                  passwordRequirement(
                    'Must contain at least one letter',
                    hasLetter,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: ColorPalette.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  passwordRequirement(
                    'Must match password above',
                    passwordsMatch,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: canActivate
                          ? () {
                              print(
                                  "email: ${verificationController.email.value}");
                              print("password: $password");
                              // authController.signIn(verificationController.email.value, password);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Activate Account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Get.toNamed(Routes.SIGN_IN);
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: ColorPalette.green,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordRequirement(String text, bool satisfied) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: satisfied ? ColorPalette.green : const Color(0xff9CA3AF),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: satisfied ? ColorPalette.green : const Color(0xff6B7280),
                fontWeight: satisfied ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
