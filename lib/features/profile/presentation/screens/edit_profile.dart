import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/drop_down_menu.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.scaffoldColor,
      appBar: CustomAppBar(
        title: "Edit Profile",
        centerTitle: false,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 60),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                const EditProfileHead(),
                const SizedBox(
                  height: 50,
                ),
                EditProfileFields(),
              ],
            ),
          )),
    );
  }
}

class EditProfileHead extends StatelessWidget {
  const EditProfileHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage("assets/images/profile/therapist.png"),
              radius: 60,
            ),
            // UserAvatar(),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              width: 200,
              child: CustomButton(
                onPressed: () {},
                child: const Text(
                  'Edit profile picture',
                  style: TextStyle(
                      color: ColorPalette.white, fontSize: AppFonts.baseSize),
                ),
              ),
            ),
            // SettingsButton(
            //   label: 'Sign out',
            //   prefixIconData: TranquilIcons.sign_out,
            //   prefixIconColor: ColorPalette.red,
            //   onPressed: () => showDialog(
            //     context: context,
            //     builder: (_) => SignOutDialog(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class EditProfileFields extends StatelessWidget {
  EditProfileFields({Key? key}) : super(key: key);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController timeZoneController = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController certificationController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController yearGraduatedController = TextEditingController();
  final TextEditingController modalitiesController = TextEditingController();
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
        nameFormField(
            profileController.editUser.value.firstName, firstNameController),
        const SizedBox(height: 12),
        const Text("Last name"),
        const SizedBox(height: 8),
        nameFormField(
          profileController.editUser.value.lastName,
          lastNameController,
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
        ),
        const SizedBox(height: 12),
        const Text("City"),
        const SizedBox(height: 8),
        cityFormField(
          profileController.editUser.value.location,
        ),
        const SizedBox(height: 12),
        const Text("Timezone"),
        const SizedBox(height: 8),
        timezoneField("GMT +1", timeZoneController),
        const SizedBox(height: 20),
        const Text("Bio"),
        const SizedBox(height: 8),
        bioFormField(
            "Dr Charles Richard is a licensed mental health therapist with a decade of experience. He helps clients overcome various challenges and enhance their well-being. He applies various therapy modalities to ensure his clients receive the best treatment and care. He offers a sae, supportive, and collaborative space or his clients where they can grow and thrive.",
            // profileController.editUser.value.bio,
            bioController),
        const SizedBox(height: 40),
        const Text("QUALIFICATIONS", key: Key('qualifications_title')),
        const SizedBox(height: 20),
        const Text("Name of Certification"),
        const SizedBox(height: 8),
        nameofcertification("B.Sc. (Hons) Psychology", certificationController),
        const SizedBox(height: 12),
        const Text("Institution/Awarding body"),
        const SizedBox(height: 8),
        institution("Leeds University", institutionController),
        const SizedBox(height: 12),
        const Text("Year graduated/awarded"),
        const SizedBox(height: 8),
        yearGraduated("2018", yearGraduatedController),
        const SizedBox(height: 12),
        TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            icon: Icon(
              Icons.add_circle_outline_sharp,
              color: ColorPalette.green,
            ),
            onPressed: () {},
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
        modalities("", modalitiesController),
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
        const Text(
          "INTRO MEDIA",
          style: TextStyle(
            fontSize: AppFonts.baseSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            width: displayWidth(context),
            decoration: BoxDecoration(
              color: ColorPalette.green.shade300,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(width: 1, color: ColorPalette.gray.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  width: 1, color: Color(0xFF62B778))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                                height: 24,
                                width: 24,
                                "assets/images/icons/video-play.svg"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Play video",
                              style: TextStyle(
                                color: ColorPalette.gray.shade400,
                                fontSize: AppFonts.baseSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "57 secs",
                              style: TextStyle(
                                color: ColorPalette.gray.shade300,
                                fontSize: AppFonts.defaultSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      _showDeleteVideoDialog(context);
                    },
                    child: SvgPicture.asset("assets/images/icons/trash.svg"))
              ],
            ),
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {},
            child: Text(
              "Retake video recording",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  color: ColorPalette.green),
            )),
        Container(
          padding: const EdgeInsets.all(12),
          width: displayWidth(context),
          decoration: BoxDecoration(
            color: ColorPalette.green.shade300,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1, color: ColorPalette.gray.shade100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border:
                                Border.all(width: 1, color: Color(0xFF62B778))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                              height: 24,
                              width: 24,
                              "assets/images/icons/musicnote.svg"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Play Audio",
                            style: TextStyle(
                              color: ColorPalette.gray.shade400,
                              fontSize: AppFonts.baseSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "57 secs",
                            style: TextStyle(
                              color: ColorPalette.gray.shade300,
                              fontSize: AppFonts.defaultSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/images/icons/trash.svg"))
            ],
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {},
            child: Text(
              "Retake audio recording",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  color: ColorPalette.green),
            )),
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

  void _showDeleteVideoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            backgroundColor: ColorPalette.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Delete video file?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: ColorPalette.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFFDDDDD)),
                    child: SvgPicture.asset("assets/images/icons/trash.svg")),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You need to have a video recording for your clients in your profile",
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
                          onPressed: () {},
                          text: "Delete File",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
