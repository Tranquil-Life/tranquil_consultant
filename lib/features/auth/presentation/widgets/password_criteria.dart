import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

Widget buildPasswordCriteria(AuthController controller) {
  return Column(
    children: [
      buildCriteriaRow(
        "Must be longer than 8 characters (no spaces)",
        controller.isLengthValid.value,
        initialColor: ColorPalette.grey.shade300,
      ),
      buildCriteriaRow(
        "Must have at least one special character (!@#%^&*()_+, etc)",
        controller.hasSpecialChar.value,
        initialColor: ColorPalette.grey.shade300,
      ),
      buildCriteriaRow(
        "Must have at least one digit (0 - 9)",
        controller.hasDigit.value,
        initialColor: ColorPalette.grey.shade300,
      ),
      buildCriteriaRow(
        "Must have at least one letter (a - z)",
        controller.hasLetter.value,
        initialColor: ColorPalette.grey.shade300,
      ),
    ],
  );
}

Widget buildCriteriaRow(String text, bool isValid, {Color? initialColor}) {
  return Row(
    children: [
      SvgPicture.asset(
        isValid
            ? "assets/images/icons/active_tick_circle.svg"
            : "assets/images/icons/inactive_tick_circle.svg",
        color:
        isValid ? ColorPalette.green : (initialColor ?? ColorPalette.red),
      ),
      const SizedBox(width: 8),
      Flexible(child: Text(
        text,
        style: TextStyle(
          color: isValid
              ? ColorPalette.green
              : (initialColor ?? ColorPalette.red),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),)
    ],
  );
}