import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/settings_button.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({super.key, required this.sectionTitle, required this.components});

  final String sectionTitle;
  final List<Map<String, dynamic>> components;

  @override
  Widget build(BuildContext context) {
    if (components.isEmpty) return const SizedBox.shrink(); // optional

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(sectionTitle),
        const SizedBox(height: 12),
        // Flatten items directly into the parent Column:
        Container(
          color: ColorPalette.white,
          child: Column(
            children: [
              ...components.map<Widget>((e) {
                return SettingsButton(
                  prefix: e['prefix'],
                  label: e['label'] as String,
                  suffix: e['suffix'],
                  onPressed: (e['onTap'] as VoidCallback?) ?? () {},
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(title[0].toUpperCase() + title.substring(1),
          style: TextStyle(fontSize: AppFonts.defaultSize)),

    );
  }
}