import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/custom_form_field.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_tab_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "Edit Profile",
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileHead(),
              SizedBox(
                height: 30,
              ),
              EditProfileFields(),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileHead extends StatelessWidget {
  const EditProfileHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 55,
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 200,
                child: CustomButton(
                  onPressed: () {},
                  text: "Edit profile picture",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileFields extends StatelessWidget {
  const EditProfileFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("IDENTITY"),
        const SizedBox(height: 20),
        const Text("First name"),
        nameFormField(
          profileController.editUser.value.firstName,
          TextEditingController(),
        ),
        const Text("Last name"),
        nameFormField(
          profileController.editUser.value.lastName,
          TextEditingController(),
        ),
        const Text("Title"),
        titleFormField(profileController.editUser.value.toString()),
        const SizedBox(height: 20),
        const Text("LOCATION"),
        const SizedBox(height: 20),
        const Text("Country"),
        countryFormField(""),
        const Text("City"),
        cityFormField(""),
        const Text("Bio"),
        bioFormField(""),
        const SizedBox(height: 20),
        const Text("QUALIFICATIONS"),
        const SizedBox(height: 20),
        const Text("Name of Certification"),
        nameofcertification(""),
        const Text("Institution/Awarding body"),
        institution(""),
        const Text("Year graduated/awarded"),
        yearGraduated(""),
        const Text("Modalities practiced"),
        modalities(""),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: CustomButton(
                onPressed: () {
                  _showDiscardChangesDialog(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 180,
              child: CustomButton(
                onPressed: () {},
                text: "Save Changes",
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
          title: const Center(child: Text("Discard Changes?")),
          content: const Text(
              "Do you want to exit this page without saving your changes?"),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Close",
                      // child: const Text('Cancel'),
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
        );
      },
    );
  }
}
