import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class QualificationsTabView extends StatelessWidget {
  QualificationsTabView({super.key});

  final dashboardController = DashboardController.instance;

  void removeEmptyElements(){
    // Remove empty elements
    dashboardController.modalities.value = dashboardController.modalities.where((element) => element.trim().isNotEmpty).toList();
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
                Get.toNamed(Routes.EDIT_PROFILE);
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              color: ColorPalette.green,
            ),
          ],
        ),
        // profileController.qualifications.isEmpty
        //     ? Text(
        //         "Add your qualifications. This will increase your chances of being consulted")
        //     : ListView.builder(
        //         shrinkWrap: true,
        //         physics: NeverScrollableScrollPhysics(),
        //         itemCount: profileController.qualifications.length,
        //         itemBuilder: (context, index) {
        //           int? id = profileController.qualifications[index].id;
        //           String institution =
        //               profileController.qualifications[index].institution;
        //           String certification =
        //               profileController.qualifications[index].certification;
        //           String year =
        //               profileController.qualifications[index].yearAwarded;
        //
        //           return Padding(
        //             padding: EdgeInsets.only(bottom: 16),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(certification),
        //                 Text(institution),
        //                 Text(year),
        //               ],
        //             ),
        //           );
        //         }),
        // if (profileController.qualifications.isEmpty)
        //   SizedBox(
        //     height: 16,
        //   ),
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
                Get.toNamed(Routes.EDIT_PROFILE);
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              color: ColorPalette.green,
            ),
          ],
        ),
        Obx((){
          if(dashboardController.modalities.isEmpty) {
            return Text("Add modalities you practice and are qualified for");
          } else {
            return Column(
            children: dashboardController.modalities
                .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.stop_circle,
                  size: 8,
                  color: ColorPalette.grey.shade800,
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
          );
          }
        }),
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
                Get.toNamed(Routes.EDIT_PROFILE);
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              color: ColorPalette.green,
            ),
          ],
        ),
        // profileController.topics.isEmpty
        //     ? Text("Add topics you are very familiar with")
        //     : Column(
        //         children: profileController.topics
        //             .map((e) => Row(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   children: [
        //                     Icon(
        //                       Icons.stop_circle,
        //                       size: 8,
        //                     ),
        //                     SizedBox(
        //                       width: 8,
        //                     ),
        //                     Text(
        //                       e,
        //                       style: TextStyle(
        //                         fontSize: AppFonts.defaultSize,
        //                         fontWeight: FontWeight.w400,
        //                       ),
        //                     ),
        //                   ],
        //                 ))
        //             .toList(),
        //       )
      ],
    );
  }
}
