import 'package:flutter/material.dart';

Widget label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 16),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xff111827),
        fontSize: 15,
      ),
    ),
  );
}