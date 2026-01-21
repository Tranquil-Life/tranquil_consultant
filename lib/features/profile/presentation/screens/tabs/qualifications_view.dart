import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class QualificationsTabView extends StatelessWidget {
  QualificationsTabView({super.key});

  final dashboardController = DashboardController.instance;


  @override
  Widget build(BuildContext context) {
    return Obx((){
      // compute a cleaned list WITHOUT writing back to the controller
      final modalities = dashboardController.modalities
          .where((e) => e.trim().isNotEmpty)
          .toList();

      final qualifications = dashboardController.qualifications;

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
          qualifications.isEmpty
              ? Text(
              "Add your qualifications. This will increase your chances of being consulted")
              : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: qualifications.length,
              itemBuilder: (context, index) {
                int? id = qualifications[index].id;
                String institution =
                    qualifications[index].institution;
                String certification =
                    qualifications[index].certification;
                String year =
                    qualifications[index].yearAwarded;

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
          if (qualifications.isEmpty)
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
          if (modalities.isEmpty)
            CustomText(text: "Add modalities you practice and are qualified for", color: ColorPalette.grey[800],)
          else
            Column(
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
            )


          ///topics
          // SizedBox(
          //   height: 16,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       "Topics",
          //       style: TextStyle(
          //         fontSize: AppFonts.defaultSize,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Get.toNamed(Routes.EDIT_PROFILE);
          //       },
          //       icon: const Icon(
          //         Icons.edit_outlined,
          //         size: 20,
          //       ),
          //       color: ColorPalette.green,
          //     ),
          //   ],
          // ),
          // dashboardController.topics.isEmpty
          //     ? Text("Add topics you are very familiar with")
          //     : Column(
          //         children: dashboardController.topics
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
    });
  }
}
