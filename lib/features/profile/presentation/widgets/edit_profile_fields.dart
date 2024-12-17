import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/broken_vertical_line.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/intro_media_section.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/qualification_fields.dart';

class EditProfileFields extends StatefulWidget {
  const EditProfileFields({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  State<EditProfileFields> createState() => _EditProfileFieldsState();
}

class _EditProfileFieldsState extends State<EditProfileFields> {

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "IDENTITY",
          style: TextStyle(
            fontSize: AppFonts.baseSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        const Text("First name"),
        const SizedBox(height: 8),
        nameFormField(widget.profileController.editUser.value.firstName,
            widget.profileController.firstNameTEC),
        const SizedBox(height: 12),
        const Text("Last name"),
        const SizedBox(height: 8),
        nameFormField(
          widget.profileController.editUser.value.lastName,
          widget.profileController.lastNameTEC,
        ),
        const SizedBox(height: 12),
        const Text("Title"),
        const SizedBox(height: 8),
        titleFormField('', widget.profileController),
        const SizedBox(height: 25),
        const Text("LOCATION"),
        const SizedBox(height: 20),
        const Text("Country"),
        const SizedBox(height: 8),
        countryFormField(
          widget.profileController.editUser.value.location,
            widget.profileController
        ),
        const SizedBox(height: 12),
        const Text("City"),
        const SizedBox(height: 8),
        cityFormField(
          widget.profileController.editUser.value.location, widget.profileController
        ),
        const SizedBox(height: 12),
        const Text("Timezone"),
        const SizedBox(height: 8),
        timezoneField(widget.profileController),
        const SizedBox(height: 20),
        const Text("Bio"),
        const SizedBox(height: 8),
        bioFormField(
            hintBio,
            // widget.profileController.editUser.value.bio,
            widget.profileController),
        const SizedBox(height: 40),
        const Text("QUALIFICATIONS", key: Key('qualifications_title')),
        const SizedBox(height: 20),

        //QUALIFICATIONS
        Obx(
          () => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.profileController.qualifications.length,
              itemBuilder: (context, index) {
                String institution = widget.profileController.qualifications[index]
                        ['institution'] ??
                    '';
                String certification = widget.profileController.qualifications[index]
                        ['certification'] ??
                    '';
                String year = widget.profileController.qualifications[index]
                        ['year_awarded'] ??
                    '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QualificationFields(
                      profileController: widget.profileController,
                      index: index,
                      institution: institution,
                      certification: certification,
                      yearAwarded: year,
                    ),
                    if (index != widget.profileController.qualifications.length - 1)
                      Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 8),
                        child: BrokenVerticalLine(),
                      )
                  ],
                );
              }),
        ),
        TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            icon: Icon(
              Icons.add_circle_outline_sharp,
              color: ColorPalette.green,
            ),
            onPressed: () {
              if (hasEmptyMapOrEmptyKeyValue(
                  widget.profileController.qualifications)) {
                if (kDebugMode) {
                  print(
                      "There is an empty map or a map with empty key-value pairs.");
                }
              } else {
                widget.profileController.qualifications.add({});
              }

            },
            label: Text(
              "Add Qualification",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.green),
            )),
        const SizedBox(height: 20),
        const Text("Modalities practiced"),
        const SizedBox(height: 8),
        modalities("", widget.profileController.modalitiesTEC),
        const SizedBox(height: 8),
        Text(
          "Select at least 1, and no more than 5",
          style: TextStyle(
            color: ColorPalette.gray.shade800,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),

        IntroMediaSection(),


      ],
    );
  }
}

bool hasEmptyMapOrEmptyKeyValue(List<Map<String, dynamic>> qualifications) {
  // Iterate over each map in the qualifications list
  for (var qualification in qualifications) {
    // Check if the map is empty or contains empty key-value pairs
    if (qualification.isEmpty ||
        qualification.values.any((value) => value == null || value == '')) {
      return true; // Found an empty map or map with empty key-value pair
    }
  }
  return false; // No empty maps or key-value pairs found
}
