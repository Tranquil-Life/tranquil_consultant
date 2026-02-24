import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/solo_based_verification.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/bg.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/means_of_id_field.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({super.key});

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  final authController = AuthController.instance;

  // final _formKey = GlobalKey<FormState>();
  //
  // @override
  // void didChangeDependencies() {
  //   // authController.dateTEC.text = authController.params.birthDate;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: ColorPalette.scaffoldColor,
        ),
        backgroundColor: ColorPalette.scaffoldColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter your details",
                    style: TextStyle(
                      color: ColorPalette.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Put your details in the form below to continue your registration",
                    style: TextStyle(
                        fontSize: AppFonts.defaultSize,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.grey.shade500),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'First name',
                    style: TextStyle(color: ColorPalette.grey[600]),
                  ),
                  SizedBox(height: 8),
                  firstNameField(),
                  SizedBox(height: 12),
                  Text(
                    'Last name',
                    style: TextStyle(color: ColorPalette.grey[600]),
                  ),
                  SizedBox(height: 8),
                  lastNameField(),
                  SizedBox(
                    height: displayHeight(context) / 10,
                  ),
                  CustomButton(
                    text: "Continue",
                      onPressed: () {
                    debugPrint("First name: ${authController.params.firstName}\nLast name: ${authController.params.lastName}");
                    Get.to(SoloBasedVerification());
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );

    //   CustomBGWidget(
    //   title: 'Sign Up',
    //   child: SingleChildScrollView(
    //     physics: const ClampingScrollPhysics(),
    //     child: Column(
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.only(top: 32, bottom: 20),
    //           child: Text('Register Account', style: TextStyle(fontSize: 36)),
    //         ),
    //         const Text('Complete your profile', style: TextStyle(fontSize: 18)),
    //         const SizedBox(height: 24),
    //         Form(
    //           key: _formKey,
    //           child: Column(
    //             children: [
    //               //first name
    //               Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 12),
    //                   child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(8.0),
    //                       child: firstNameField()
    //                   )
    //               ),
    //
    //               //last name
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 12),
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.circular(8.0),
    //                   child: lastNameField(),
    //                 ),
    //               ),
    //
    //               //Date of birth
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(vertical: 12),
    //                 child: Stack(
    //                   children: [
    //                     IgnorePointer(
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(8),
    //                           child: dateOfBirthField(),
    //                         )
    //                     ),
    //                     Positioned.fill(
    //                       child: GestureDetector(
    //                         onTap: () async {
    //                           FocusManager.instance.primaryFocus?.unfocus();
    //                           final date = await showCustomDatePicker(
    //                             context,
    //                             minDateFromNow: DateTime(-100, 0, 0),
    //                             maxDateFromNow: DateTime(-16, 0, 0),
    //                           );
    //                           if (date != null) {
    //                             authController.dateTEC.text = date.formatted;
    //                             // authController.params.birthDate = date.folded;
    //                           }
    //                         },
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //
    //               //attach resumé
    //               // CurriculumVitaeField(),
    //
    //               //Attach ID
    //               MeansOfIdField()
    //             ],
    //           ),
    //         ),
    //         const SizedBox(height: 32),
    //         CustomButton(
    //             text: 'Next',
    //             onPressed: (){
    //               // if (_formKey.currentState!.validate()) {
    //               //   Get.toNamed(Routes.SIGN_UP_2);
    //               // }
    //
    //               Get.to(SoloBasedVerification());
    //
    //             })
    //       ],
    //     ),
    //   ),
    // );
  }
}
