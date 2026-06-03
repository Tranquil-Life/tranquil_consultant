import 'package:flutter/material.dart';

Widget noticeBox() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xffEEF7F0),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.shield_outlined,
          color: Color(0xff388D4D),
          size: 30,
        ),
        SizedBox(width: 14),
        Expanded(
          child: Text(
            'We only accept licensed mental health professionals. '
                'Your information is secure and will only be used for verification purposes.',
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Color(0xff1F2937),
            ),
          ),
        ),
      ],
    ),
  );
}