import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/section_widget.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/settings_button.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/sign_out_dialog.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/theme_brightness_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CustomAppBar(
          backgroundColor: Colors.grey.shade100,
          title: "Settings",
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(padding: EdgeInsets.all(24),
            child: Column(
              children: settings.entries.map((entry) {
                return SectionWidget(
                  sectionTitle: entry.key, // e.g., "general"
                  components: entry.value, // your list of maps
                );
              }).toList(),
            )),
          ),
        ));
  }
}
