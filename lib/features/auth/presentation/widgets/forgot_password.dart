import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/properties.dart';
import 'package:tl_consultant/core/utils/services/validators.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  String email = '';
  String error = '';

  void _continue() {
    if (Validator.isEmail(email)) {
      setState(() => error = '');
      AuthController.instance.resetPassword();
    } else {
      setState(() => error = 'Please input a valid email address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(38),
      decoration: bottomSheetDecoration,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Forgot Password?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            const Text(
              'A password reset link will be sent to your mail.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, height: 1.3),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Your account's email address",
                ),
                onChanged: (val) {
                  setState(() => email = val);
                  if (val.isEmpty) {
                    setState(() => error = 'Please input your email address');
                  } else if (error.isNotEmpty) {
                    setState(() => error = '');
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 30,
              child: Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: Center(
                child: ElevatedButton(
                  onPressed: email.isEmpty ? null : _continue,
                  child: const Text('Reset Password'),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}