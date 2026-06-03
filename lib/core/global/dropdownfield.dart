import 'package:flutter/material.dart';

Widget dropdownField({
  required String? value,
  required String hint,
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value == null || value.isEmpty ? null : value,
    dropdownColor: Colors.white,
    isExpanded: true,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xff9CA3AF)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff388D4D)),
      ),
    ),
    items: items
        .map(
          (item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ),
    )
        .toList(),
    onChanged: onChanged,
  );
}