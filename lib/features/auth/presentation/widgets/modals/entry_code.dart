import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/properties.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/register.dart';

class EntryCodeModal extends StatefulWidget {
  const EntryCodeModal({super.key});

  @override
  State<EntryCodeModal> createState() => _EntryCodeModalState();
}

class _EntryCodeModalState extends State<EntryCodeModal> {
  String entryCode = '';
  String error = '';

  void _continue() {
    if (entryCode == '2ab?tl') {
      setState(() => error = '');
      Get.to(Register());
    } else {
      setState(() => error = 'Please input a valid code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Container(
        padding: const EdgeInsets.all(38),
        decoration: bottomSheetDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Input the entry code',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "The TL therapist entry code",
                    ),
                    onChanged: (val) {
                      setState(() => entryCode = val);
                      if (val.isEmpty) {
                        setState(() => error = 'Please input the entry code');
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
                      child: CustomButton(onPressed: entryCode.isEmpty ? null : _continue, text: "Enter code",)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
