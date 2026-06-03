import 'package:flutter/material.dart';

Widget stepCircle(String text, bool active) {
  return Container(
    height: 28,
    width: 28,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: active ? const Color(0xff388D4D) : Colors.white,
      border: Border.all(
        color: active ? const Color(0xff388D4D) : const Color(0xffD1D5DB),
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xff6B7280),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}