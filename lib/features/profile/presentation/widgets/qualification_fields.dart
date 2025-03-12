import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';

class QualificationFields extends StatelessWidget {
  const QualificationFields(
      {super.key,
      required this.profileController,
      required this.index,
      required this.institution,
      required this.certification,
      required this.yearAwarded,
      this.id});

  final ProfileController profileController;

  final int index;
  final int? id;
  final String certification;
  final String institution;
  final String yearAwarded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Name of Certification"),
        const SizedBox(height: 8),
        nameOfCertification(
            hint: "B.Sc. (Hons) Psychology",
            onChanged: (s) {
              userDataStore.qualifications[index]['consultant_id'] =
                  UserModel.fromJson(userDataStore.user).id;
              userDataStore.qualifications[index]['certification'] = s;
            },
            onFieldSubmitted: (s) {
              userDataStore.qualifications[index]['consultant_id'] =
                  UserModel.fromJson(userDataStore.user).id;
              userDataStore.qualifications[index]['certification'] = s;
            },
            text: certification),
        const SizedBox(height: 12),
        const Text("Institution/Awarding body"),
        const SizedBox(height: 8),
        institutionField(
            hint: "Leeds University",
            onChanged: (s) {
              userDataStore.qualifications[index]['consultant_id'] =
                  UserModel.fromJson(userDataStore.user).id;
              userDataStore.qualifications[index]['institution'] = s;
            },
            onFieldSubmitted: (s) {
              userDataStore.qualifications[index]['consultant_id'] =
                  UserModel.fromJson(userDataStore.user).id;
              userDataStore.qualifications[index]['institution'] = s;
            },
            text: institution),
        const SizedBox(height: 12),
        const Text("Year graduated/awarded"),
        const SizedBox(height: 8),
        yearGraduatedField(
            hint: "2018",
            onChanged: (s) {
              userDataStore.qualifications[index]['consultant_id'] =
                  UserModel.fromJson(userDataStore.user).id;
              userDataStore.qualifications[index]['year_awarded'] = s;
            },
            onFieldSubmitted: (s) {
              userDataStore.qualifications[index]['consultant_id'] =
                  UserModel.fromJson(userDataStore.user).id;
              userDataStore.qualifications[index]['year_awarded'] = s;
            },
            text: yearAwarded),
        const SizedBox(height: 12),
       Obx(()=> Align(
           alignment: Alignment.bottomRight,
           child: (profileController.deletingId.value == id)
               ? Text("Deleting...", style: TextStyle(color: ColorPalette.red))
               : GestureDetector(
             onTap: () {
               profileController.deleteQualification(id, index);
             },
             child: Padding(
                 padding: EdgeInsets.only(right: 8),
                 child: SvgPicture.asset(SvgElements.svgDeleteIcon)),
           )))
      ],
    );
  }
}
