import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/section_widget.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/sign_out_dialog.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalette.scaffoldColor,
        appBar: CustomAppBar(
          backgroundColor: ColorPalette.scaffoldColor,
          title: "Settings",
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(children: [
                  ...settings.entries.map((entry) {
                    return Padding(
                      padding: settings.entries.first.key != entry.key
                          ? EdgeInsets.only(top: 32)
                          : EdgeInsets.zero,
                      child: SectionWidget(
                        sectionTitle: entry.key, // e.g., "general"
                        components: entry.value, // your list of maps
                      ),
                    );
                  }),
                  SizedBox(height: 32),
                  CustomButton(
                    showBorder: true,
                    bgColor: ColorPalette.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => SignOutDialog());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: "Log out",
                          color: ColorPalette.green,
                        ),
                        SizedBox(width: 8),
                        SvgPicture.asset(SvgElements.svgLogOut)
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // CustomButton(
                  //   showBorder: true,
                  //   borderColor: ColorPalette.red,
                  //   bgColor: ColorPalette.white,
                  //   onPressed: () {},
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       CustomText(
                  //         text: "Delete account",
                  //         color: ColorPalette.red,
                  //       ),
                  //       SizedBox(width: 8),
                  //       SvgPicture.asset(SvgElements.svgDelete, colorFilter: ColorFilter.mode(
                  //           ColorPalette.red, BlendMode.srcIn))
                  //     ],
                  //   ),
                  // )
                ])),
          ),
        ));
  }
}
