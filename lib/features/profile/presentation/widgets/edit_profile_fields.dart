import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/broken_vertical_line.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/intro_media_section.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/qualification_fields.dart';

class EditProfileFields extends StatefulWidget {
  const EditProfileFields(
      {super.key,
      required this.profileController,
      required this.videoRecordingController});

  final ProfileController profileController;
  final VideoRecordingController videoRecordingController;

  @override
  State<EditProfileFields> createState() => _EditProfileFieldsState();
}

class _EditProfileFieldsState extends State<EditProfileFields> {
  final dashboardController = DashboardController.instance;
  @override
  void initState() {
    getInfo();
    // widget.profileController.getQualifications();
    // widget.profileController.modalitiesTEC.text =
    //     widget.profileController.modalities.join(', ');
    // widget.profileController
    //     .containsTitle(widget.profileController.lastNameTEC.text);

    super.initState();
  }

  void getInfo(){
    widget.profileController.firstNameTEC.text = dashboardController.firstName.value;
    widget.profileController.lastNameTEC.text = dashboardController.lastName.value;
    widget.profileController.countryTEC.text = dashboardController.country.value;
    widget.profileController.stateTEC.text = dashboardController.state.value;
    widget.profileController.bioTEC.text = dashboardController.bio.value;

  }

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
        ///OLD
        // nameFormField(widget.profileController.editUser.value.firstName,
        //     widget.profileController.firstNameTEC),

        ///NEW
        nameFormField("Your first name",
            widget.profileController.firstNameTEC),
        const SizedBox(height: 12),
        const Text("Last name"),
        const SizedBox(height: 8),
        // nameFormField(
        //   widget.profileController.editUser.value.lastName,
        //   widget.profileController.lastNameTEC,
        // ),

        ///NEW
        nameFormField("Your last name",
            widget.profileController.lastNameTEC),

        // const SizedBox(height: 12),
        // const Text("Title"),
        // const SizedBox(height: 8),
        // Obx(() => titleFormField(
        //         widget.profileController.titles.isEmpty
        //             ? 'Optional'
        //             : widget.profileController.titles.join(', '),
        //         widget.profileController, () {
        //       Get.dialog(
        //         AlertDialog(
        //           backgroundColor: Colors.white,
        //           contentPadding: EdgeInsets.only(bottom: 20),
        //           titlePadding:
        //               EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        //           title: Column(
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('Titles'),
        //                   GestureDetector(
        //                     onTap: () {
        //                       Get.back();
        //                     },
        //                     child: SvgPicture.asset(
        //                         SvgElements.svgHexagonCloseIcon),
        //                   )
        //                 ],
        //               ),
        //               Divider(),
        //               SizedBox(height: 20),
        //               Text(
        //                 "Select your title(s) if you have any.\n\nNote: you can’t select more than 5",
        //                 style: TextStyle(fontSize: 14),
        //               ),
        //             ],
        //           ),
        //           content: StatefulBuilder(
        //             builder: (context, setState) {
        //               return SingleChildScrollView(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: titleOptions.map((title) {
        //                     return Obx(() {
        //                       bool isSelected = widget
        //                           .profileController.titles
        //                           .contains(title);
        //
        //                       void toggleSelection() {
        //                         if (!isSelected &&
        //                             widget.profileController.titles
        //                                 .length >=
        //                                 5) {
        //                           Get.snackbar(
        //                             'Limit Reached',
        //                             'You cannot select more than 5 titles.',
        //                             snackPosition: SnackPosition.BOTTOM,
        //                           );
        //                           return;
        //                         }
        //
        //                         if (isSelected) {
        //                           widget.profileController.titles
        //                               .remove(title);
        //                         } else {
        //                           widget.profileController.titles
        //                               .add(title);
        //                         }
        //
        //                         setState(() {}); // Update local state
        //                       }
        //
        //                       return ListTile(
        //                         contentPadding: EdgeInsets.all(0),
        //                         leading: Checkbox(
        //                           activeColor: ColorPalette.green,
        //                           value: isSelected,
        //                           onChanged: (value) {
        //                             toggleSelection();
        //                           },
        //                         ),
        //                         title: Text(title,
        //                             style: TextStyle(fontSize: 14)),
        //                         onTap:
        //                         toggleSelection, // Make the ListTile clickable
        //                       );
        //                     });
        //                   }).toList(),
        //                 ),
        //
        //
        //                 // Column(
        //                 //   crossAxisAlignment: CrossAxisAlignment.start,
        //                 //   children: [
        //                 //
        //                 //   ],
        //                 // ),
        //               );
        //             },
        //           ),
        //         ),
        //       );
        //     })),
        const SizedBox(height: 25),
        const Text("LOCATION"),
        const SizedBox(height: 20),
        const Text("Country"),
        const SizedBox(height: 8),
        countryFormField("Your country",
            widget.profileController.countryTEC),
        const SizedBox(height: 12),
        const Text("State"),
        const SizedBox(height: 8),
        stateFormField("Your state",
            widget.profileController.stateTEC),
        const SizedBox(height: 12),
        const Text("Timezone"),
        const SizedBox(height: 8),
        timezoneField(dashboardController.timezone.value),
        const SizedBox(height: 20),
        const Text("Bio"),
        const SizedBox(height: 8),
        bioFormField(
            hintBio,
            widget.profileController.bioTEC),
        const SizedBox(height: 40),
        const Text("QUALIFICATIONS", key: Key('qualifications_title')),

        //QUALIFICATIONS
        Obx(
          () => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dashboardController.qualifications.length,
              itemBuilder: (context, index) {
                int? id = dashboardController.qualifications[index].id;
                String institution =
                    dashboardController.qualifications[index].institution;
                String certification = dashboardController.qualifications[index].certification;
                String year =
                    dashboardController.qualifications[index].yearAwarded;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: QualificationFields(
                          profileController: widget.profileController,
                          id: id,
                          index: index,
                          institution: institution,
                          certification: certification,
                          yearAwarded: year,
                        )),
                    if (index !=
                        dashboardController.qualifications.length - 1)
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
              checkQualifications(List<Map<String, dynamic>>.from(
                  userDataStore.qualifications));
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
        Obx(()=>modalities("Add your modalities", dashboardController.modalities, () {
          Get.dialog(
            AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(bottom: 20),
              titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Modalities'),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child:
                        SvgPicture.asset(SvgElements.svgHexagonCloseIcon),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    "Select the specific modalities you practice and are qualified for.\n\nNote: you can’t select more than 5",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: modalityOptions.map((modality) {
                            return Obx(() {
                              bool isSelected = dashboardController.modalities
                                  .contains(modality);

                              void toggleSelection() {
                                if (!isSelected &&
                                    dashboardController.modalities
                                        .length >=
                                        5) {
                                  Get.snackbar(
                                    'Limit Reached',
                                    'You cannot select more than 5 modalities.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                if (isSelected) {
                                  dashboardController.modalities
                                      .remove(modality);
                                } else {
                                  dashboardController.modalities
                                      .add(modality);
                                }

                                // setState(() {}); // Update local state

                                // dashboardController.modalities =
                                //     widget.profileController.modalities
                                //         .join(', ');
                              }

                              return ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: Checkbox(
                                  activeColor: ColorPalette.green,
                                  value: isSelected,
                                  onChanged: (value) {
                                    toggleSelection();
                                  },
                                ),
                                title: Text(modality,
                                    style: TextStyle(fontSize: 14)),
                                onTap:
                                toggleSelection, // Make the ListTile clickable
                              );
                            });
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }),),
        const SizedBox(height: 8),
        Text(
          "Select at least 1, and no more than 5",
          style: TextStyle(
            color: ColorPalette.grey.shade800,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),

        // //VIDEO AND AUDIO RECORDINGS
        // IntroMediaSection(
        //     profileController: widget.profileController,
        //     videoRecordingController: widget.videoRecordingController),
      ],
    );
  }

  void checkQualifications(List<Map<String, dynamic>> qualifications) {
    // Check if any item is missing the `certification` key or has an empty certification
    bool hasMissingOrEmptyCertification = qualifications.any((item) =>
        !item.containsKey('certification') ||
        (item['certification']?.isEmpty ?? true));

    if (hasMissingOrEmptyCertification) {
      if (kDebugMode) {
        print("Please fill in the current on before adding another");
      }
    } else {
      userDataStore.qualifications.add(<String, dynamic>{});
      List<Map<String, dynamic>> updatedQualifications =
          List<Map<String, dynamic>>.from(userDataStore.qualifications);

      // widget.profileController.getQualifications();
    }
  }
}
