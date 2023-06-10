import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final TextEditingController? textEditingController;
  final bool showCursor;
  final Function()? onTap;
  final TextInputType? textInputType;
  final bool readOnly, obscureText;
  final Widget? suffix, prefix;
  final String? Function(String?)? validator;
  void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  CustomFormField({Key? key,
    this.hint = "",
    this.textEditingController,
    this.showCursor = false,
    this.onTap,
    this.textInputType,
    this.readOnly = false,
    this.obscureText= false,
    this.suffix,
    this.prefix,
    this.validator,
    this.initialValue,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 18, color: ColorPalette.black),
      autocorrect: false,
      readOnly: readOnly,
      initialValue: initialValue,
      obscureText: obscureText,
      controller: textEditingController,
      validator: validator,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        const TextStyle(
            fontSize: 18, color: Colors.grey),
        errorStyle: const TextStyle(color: Colors.white, fontSize: 14),
        fillColor: Colors.white,
        border: InputBorder.none,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: (hint=='Password' || hint=='Display Name') ? 17.0 : 22.0, horizontal: 24.0),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
          suffix: suffix,
          prefix: prefix),
    );
  }
}

