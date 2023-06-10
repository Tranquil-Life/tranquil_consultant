import 'package:flutter/material.dart';

class DisplayNameInfoDialog extends StatelessWidget {
  const DisplayNameInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Your "Display name" is what would be displayed during consultations. Your first name and last name will be kept private.',
        style: TextStyle(fontSize: 17, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}
