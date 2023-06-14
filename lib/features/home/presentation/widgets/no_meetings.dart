import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';


class NoMeetingsWidget extends StatelessWidget {
  const NoMeetingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 10, 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Image.asset(
                'assets/images/no_meeting.png'),
          ),
          const SizedBox(height: 12),
          const Text(
            'No meeting',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}