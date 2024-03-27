import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class QualificationsTabView extends StatelessWidget {
  const QualificationsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Qualification",
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: () {
                Get.to(const EditProfileScreen());
              },
              icon: IconButton(
                onPressed: () {
//   void _scrollToQualifications(BuildContext context) {
//   final keyContext = context.findRenderObject() as RenderBox;
//   final qualificationsContext =
//       (context.findRenderObjectByKey(const Key('qualifications_title'))
//               as RenderBox)
//           .localToGlobal(Offset.zero, ancestor: keyContext);
//   Scrollable.ensureVisible(
//     keyContext,
//     alignment: 0.5,
//     duration: const Duration(milliseconds: 500),
//     curve: Curves.easeInOut,
//   );
// }

                  Get.to(const EditProfileScreen());
                },
                icon: const Icon(Icons.edit),
                color: ColorPalette.green,
              ),
            ),
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("B.Sc. (Hons) Psychology"),
            Text("Leeds University"),
            Text(
                "Associate of Applied Science in Mental Health Clinical and Counseling Psychologyy"),
          ],
        )
      ],
    );
  }
}
