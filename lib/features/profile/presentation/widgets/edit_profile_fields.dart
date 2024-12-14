import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/broken_vertical_line.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/intro_media_section.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/qualification_fields.dart';

class EditProfileFields extends StatelessWidget {
  const EditProfileFields({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());

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
        nameFormField(profileController.editUser.value.firstName,
            profileController.firstNameTEC),
        const SizedBox(height: 12),
        const Text("Last name"),
        const SizedBox(height: 8),
        nameFormField(
          profileController.editUser.value.lastName,
          profileController.lastNameTEC,
        ),
        const SizedBox(height: 12),
        const Text("Title"),
        const SizedBox(height: 8),
        titleFormField(""),
        const SizedBox(height: 25),
        const Text("LOCATION"),
        const SizedBox(height: 20),
        const Text("Country"),
        const SizedBox(height: 8),
        countryFormField(
          profileController.editUser.value.location,
            profileController
        ),
        const SizedBox(height: 12),
        const Text("City"),
        const SizedBox(height: 8),
        cityFormField(
          profileController.editUser.value.location, profileController
        ),
        const SizedBox(height: 12),
        const Text("Timezone"),
        const SizedBox(height: 8),
        timezoneField(profileController),
        const SizedBox(height: 20),
        const Text("Bio"),
        const SizedBox(height: 8),
        bioFormField(
            "Dr Charles Richard is a licensed mental health therapist with a decade of experience. He helps clients overcome various challenges and enhance their well-being. He applies various therapy modalities to ensure his clients receive the best treatment and care. He offers a sae, supportive, and collaborative space or his clients where they can grow and thrive.",
            // profileController.editUser.value.bio,
            profileController.bioTEC),
        const SizedBox(height: 40),
        const Text("QUALIFICATIONS", key: Key('qualifications_title')),
        const SizedBox(height: 20),

        //QUALIFICATIONS
        Obx(
          () => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: profileController.qualifications.length,
              itemBuilder: (context, index) {
                String institution = profileController.qualifications[index]
                        ['institution'] ??
                    '';
                String certification = profileController.qualifications[index]
                        ['certification'] ??
                    '';
                String year = profileController.qualifications[index]
                        ['year_awarded'] ??
                    '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QualificationFields(
                      profileController: profileController,
                      index: index,
                      institution: institution,
                      certification: certification,
                      yearAwarded: year,
                    ),
                    if (index != profileController.qualifications.length - 1)
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
                  profileController.qualifications)) {
                if (kDebugMode) {
                  print(
                      "There is an empty map or a map with empty key-value pairs.");
                }
              } else {
                profileController.qualifications.add({});
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
        modalities("", profileController.modalitiesTEC),
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

        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showDiscardChangesDialog(context);
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 1,
                      color: ColorPalette.green.shade500,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.green.shade500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: CustomButton(
                onPressed: () {
                  // profileController.updateUser(
                  //   EditUser(
                  //     firstName: firstNameController.text,
                  //     lastName: lastNameController.text,
                  //   ),
                  // );
                },
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                      color: Colors.white, fontSize: AppFonts.defaultSize),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _showDiscardChangesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: ColorPalette.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Discard changes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.black),
              ),
              SizedBox(
                height: 20,
              ),
              SvgPicture.asset("assets/images/icons/container.svg"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Do you want to exit this page without saving your changes?",
                style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.gray.shade800),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 1,
                              color: ColorPalette.green.shade500,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Close",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.green.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          // Pop EditProfileScreen and go back to the previous screen
                        },
                        text: "Cancel",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
