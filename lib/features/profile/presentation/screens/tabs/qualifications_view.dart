import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class QualificationsTabView extends StatelessWidget {
  const QualificationsTabView({super.key, required this.profileController});

  final ProfileController profileController;

  removeEmptyElements(){
    // Remove empty elements
    profileController.modalities.value = profileController.modalities.where((element) => element.trim().isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    removeEmptyElements();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Qualifications",
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
        profileController.qualifications.isEmpty
            ? Text(
                "Add your qualifications. This will increase your chances of being consulted")
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: profileController.qualifications.length,
                itemBuilder: (context, index) {
                  int? id = profileController.qualifications[index].id;
                  String institution =
                      profileController.qualifications[index].institution;
                  String certification =
                      profileController.qualifications[index].certification;
                  String year =
                      profileController.qualifications[index].yearAwarded;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(certification),
                        Text(institution),
                        Text(year),
                      ],
                    ),
                  );
                }),
        if (profileController.qualifications.isEmpty)
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
        profileController.modalities.isEmpty
            ? Text("Add modalities you practice and are qualified for")
            : Obx(()=>Column(
          children: profileController.modalities
              .map((e) => Row(
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
                e,
                style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ))
              .toList(),
        )),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Topics",
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
        profileController.topics.isEmpty
            ? Text("Add topics you are very familiar with")
            : Column(
                children: profileController.topics
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.stop_circle,
                              size: 8,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              e,
                              style: TextStyle(
                                fontSize: AppFonts.defaultSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              )
      ],
    );
  }
}
