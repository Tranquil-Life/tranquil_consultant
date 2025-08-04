import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tl_consultant/core/theme/colors.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  final String hint;
  final Color? hintColor;
  final String? errorText;
  final String? initialValue;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? textEditingController;
  final bool showCursor;
  final double? verContentPadding;
  final double? horContentPadding;
  final Function()? onTap;
  final TextInputType? textInputType;
  final bool readOnly, obscureText;
  final Widget? suffix, prefix;
  int? maxLines, maxLength;
  final String? Function(String?)? validator;
  void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatter;

  CustomFormField(
      {super.key,
      this.hint = "",
      this.textEditingController,
      this.showCursor = false,
      this.onTap,
      this.textInputType,
      this.readOnly = false,
      this.obscureText = false,
      this.suffix,
      this.errorText,
      this.prefix,
      this.maxLength,
      this.maxLines,
      this.validator,
      this.initialValue,
      this.textInputAction,
      this.verContentPadding,
      this.horContentPadding,
      this.textCapitalization = TextCapitalization.none,
      this.onChanged,
      this.hintColor,
      this.onFieldSubmitted,
      this.inputFormatter});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 18, color: ColorPalette.black),
      autocorrect: false,
      readOnly: readOnly,
      // initialValue: initialValue,
      obscureText: obscureText,
      controller: textEditingController,
      validator: validator,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatter,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          errorText: errorText,
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: hintColor ?? ColorPalette.grey[200]),
          errorStyle: const TextStyle(color: ColorPalette.white, fontSize: 14),
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(width: 1, color: ColorPalette.grey.shade900)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(width: 1, color: ColorPalette.grey.shade900)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(width: 1, color: ColorPalette.red)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(width: 1, color: ColorPalette.red)),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
              vertical: verContentPadding ?? 22.0,
              horizontal: horContentPadding ?? 16.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: suffix,
          prefix: prefix),
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
    );
  }
}
