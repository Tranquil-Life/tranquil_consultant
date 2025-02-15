import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/dialogs.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';

class SignOutDialog extends StatefulWidget {
  const SignOutDialog({super.key});

  @override
  State<SignOutDialog> createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  SettingsController settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: 'Sign Out?',
      bodyText: 'You are about to sign out of your account on this device.',
      yesDialog: DialogOption(
        'Sign Out',
        onPressed: () async{
          await settingsController.signOut();
          AppData.isSignedIn = false;
        },
      ),
    );
  }
}