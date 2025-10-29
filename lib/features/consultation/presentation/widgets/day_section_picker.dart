//DAY SECTION PICKER
import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_section_widget.dart';

class DaySectionPicker extends StatefulWidget {
  const DaySectionPicker({super.key, this.onDaySelected});
  final Function(bool)? onDaySelected;

  @override
  State<DaySectionPicker> createState() => DaySectionPickerState();
}

class DaySectionPickerState extends State<DaySectionPicker> {
  bool isNightSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DaySectionWidget(
            title: 'Daytime',
            icon: TranquilIcons.bright,
            isSelected: !isNightSelected,
            onPressed: () {
              setState(() => isNightSelected = false);
              widget.onDaySelected?.call(false);
            },
          ),
        ),
        const SizedBox(width: 12), // reduced from 24
        Expanded(
          child: DaySectionWidget(
            title: 'Nighttime',
            icon: TranquilIcons.night,
            isSelected: isNightSelected,
            onPressed: () {
              setState(() => isNightSelected = true);
              widget.onDaySelected?.call(true);
            },
          ),
        ),
      ],
    );
  }
}
