import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class QualificationsTabView extends StatelessWidget {
  const QualificationsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Qualification",
              style: TextStyle(
                fontSize: AppFonts.defaultSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(const EditProfileScreen());
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              color: ColorPalette.green,
            ),
          ],
        ),
        Text(
          "B.Sc. (Hons) Psychology",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "Leeds University",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "2018",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          "Associate of Applied Science in Mental Health Clinical and Counseling Psychology",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "San Jacinto Community College",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "2021",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          "Certified Clinical Mental Health Counselor",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "National Board for Certified Counselor (NBCC)",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "2024",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Modalities",
              style: TextStyle(
                fontSize: AppFonts.defaultSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(const EditProfileScreen());
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              color: ColorPalette.green,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.stop_circle,
              size: 8,
              color: ColorPalette.gray.shade800,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Psychodynamic Therapy",
              style: TextStyle(
                fontSize: AppFonts.defaultSize,
                color: ColorPalette.gray.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.stop_circle,
              size: 8,
              color: ColorPalette.gray.shade800,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Behavioral Therapy",
              style: TextStyle(
                fontSize: AppFonts.defaultSize,
                color: ColorPalette.gray.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.stop_circle,
              size: 8,
              color: ColorPalette.gray.shade800,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Cognitive Therapy",
              style: TextStyle(
                fontSize: AppFonts.defaultSize,
                color: ColorPalette.gray.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
