import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class YearsOfExperienceModal extends StatefulWidget {
  const YearsOfExperienceModal({Key? key}) : super(key: key);

  @override
  State<YearsOfExperienceModal> createState() => _YearsOfExperienceModalState();
}

class _YearsOfExperienceModalState extends State<YearsOfExperienceModal> {
  List options = [
    "5 - 10",
    "10 - 15",
    "15 - 20",
    "20 - 25",
    ">25",
  ];

  selectOption(String option) {
    AuthController.instance.yearsOfExperienceTEC.text = option;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: displayHeight(context) * 0.08,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, int index) {
                  final item = options[index];
                  return TextButton(
                      onPressed: () {
                        Get.back();
                        selectOption(item);
                      },
                      child: Text(item,
                          style: const TextStyle(
                              color: ColorPalette.black,
                              fontSize: AppFonts.defaultSize)));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
