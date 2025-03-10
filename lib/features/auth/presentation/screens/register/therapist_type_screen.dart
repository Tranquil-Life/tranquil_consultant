import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/register.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/modals/entry_code.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/therapist_type_item.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  final AuthController authController = Get.put(AuthController());

  var types = [
    {
      'heading': 'Solo practitioner',
      'body': 'I work independently',
      'type': solo,
      'icon': SvgElements.svgUserIcon
    },
    {
      'heading': 'Agency-based therapist',
      'body': 'I work on-staff with an organization',
      'type': agency,
      'icon': SvgElements.svgPersonGroupIcon
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Get started',
        centerTitle: false,
        onBackPressed: () => Get.back(),
      ),
      backgroundColor: ColorPalette.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      "What kind of Therapist are you?",
                      style: TextStyle(
                        color: ColorPalette.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Select an option to proceed",
                      style: TextStyle(
                        color: ColorPalette.grey.shade300,
                        fontSize: AppFonts.defaultSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    //The type items
                    Column(
                        children: types
                            .map((e) => Padding(
                                padding: EdgeInsets.only(bottom: 24),
                                child: TherapistTypeItem(
                                  onTap: () {
                                    authController.selectedType(e['type']);
                                  },
                                  bgColor:
                                      authController.selectedType.value == e['type']
                                          ? ColorPalette.green
                                          : ColorPalette.green[300]!,
                                  iconColor:
                                      authController.selectedType.value == e['type']
                                          ? ColorPalette.white
                                          : ColorPalette.grey[600],
                                  radioFillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    return (authController.selectedType.value ==
                                            e['type'])
                                        ? ColorPalette.white
                                        : ColorPalette.grey[900]!;
                                  }),
                                  radioValue: e['type']!,
                                  radioGroupValue:
                                      authController.selectedType.value,
                                  heading: e['heading']!,
                                  body: e['body']!,
                                  headingTextColor:
                                      authController.selectedType.value == e['type']
                                          ? ColorPalette.white
                                          : ColorPalette.grey.shade400,
                                  bodyTextColor:  authController.selectedType.value == e['type']
                                      ? ColorPalette.white
                                      : ColorPalette.grey.shade300, icon: e['icon']!,
                                )))
                            .toList()),

                    SizedBox(
                      height: displayHeight(context)/10,
                    ),
                    CustomButton(
                      onPressed: authController.selectedType.value.isEmpty ? null : () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const EntryCodeModal(),
                        );

                      },
                      text: "Select type & proceed",
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SIGN_IN);
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: 'I have an account. ',
                            children: const [
                              TextSpan(
                                text: 'Sign me in...',
                                style: TextStyle(
                                    color: ColorPalette.green,
                                    fontFamily: AppFonts.josefinSansRegular),
                              ),
                            ],
                            style: TextStyle(color: ColorPalette.grey.shade300, fontFamily: AppFonts.josefinSansRegular, fontSize: 16),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
