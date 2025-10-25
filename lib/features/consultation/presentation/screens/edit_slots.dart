import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/day_section_option.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_card.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_section_picker.dart';

class EditSlots extends StatefulWidget {
  const EditSlots({super.key});

  @override
  State<EditSlots> createState() => _EditSlotsState();
}

class _EditSlotsState extends State<EditSlots> {
  final slotController = Get.put(SlotController());

  DaySectionOption? selectedSection = DaySectionOption.day;

  static const List<String> days = <String>[
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  /// Locally-rendered time slots for the current section (day/night)
  late List<String> timeSlots;

  @override
  void initState() {
    super.initState();
    // Load existing availability
    slotController.getAllSlots();
    // Default to day section
    timeSlots =
        generateTimeSlots(startHour: 6, endHour: 18, intervalMinutes: 60);
  }

  /// Toggle a single slot; use RxList so Obx rebuilds the grid automatically
  void toggleSelection(String slot) {
    if (slotController.timeSlots.contains(slot)) {
      slotController.timeSlots.remove(slot);
    } else {
      slotController.timeSlots.add(slot);
    }

    setState(() {});
  }

  void setSection(bool isNight) {
    selectedSection = isNight ? DaySectionOption.night : DaySectionOption.day;
    setState(() {
      timeSlots = isNight
          ? generateTimeSlots(startHour: 19, endHour: 22, intervalMinutes: 60)
          : generateTimeSlots(startHour: 6, endHour: 18, intervalMinutes: 60);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.grey[200],
        title: 'Edit Availability',
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day / Night picker
                DaySectionPicker(
                  onDaySelected: (isNightSelected) =>
                      setSection(isNightSelected),
                ),
                const SizedBox(height: 24),

                if (slotController.loading.value)
                  Center(
                    child: CircularProgressIndicator(color: ColorPalette.green),
                  ),

                Expanded(child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Make the grid a bit responsive
                    final width = constraints.maxWidth;
                    int crossAxisCount = 3;
                    if (width >= 1000) {
                      crossAxisCount = 4;
                    } else if (width <= 520) {
                      crossAxisCount = 2;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 3,
                        // childAspectRatio: 2.3,
                      ),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = timeSlots[index];
                        final isSelected =
                            slotController.timeSlots.contains(slot);
                        return Material(
                          color: isSelected ? ColorPalette.green : Colors.white,
                          borderRadius: BorderRadius.circular(
                              isSmallScreen(context) ? 32 : 64),
                          elevation: 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => toggleSelection(slot),
                            child: Center(
                              child: Text(
                                slot,
                                style: TextStyle(
                                  fontSize: isSmallScreen(context) ? 16 : 18,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),

                const SizedBox(height: 16),

                // Days selector + Save button
                Padding(
                  padding: EdgeInsets.only(bottom: 12, top: 4),
                  child: Text(
                    'Select available days',
                    style: TextStyle(
                      fontSize:
                          isSmallScreen(context) ? AppFonts.defaultSize : 24,
                      fontFamily: AppFonts.mulishSemiBold,
                    ),
                  ),
                ),

                // SizedBox(
                //   height: isSmallScreen(context) ? 80 : 120,
                //   child: ListView.separated(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.only(right: 16),
                //     itemCount: days.length,
                //     separatorBuilder: (_, __) => const SizedBox(width: 8),
                //     itemBuilder: (_, index) {
                //       final day = days[index];
                //       final isChosen =
                //           slotController.selectedDays.contains(day);
                //
                //       return DayCard(
                //         day,
                //         selected: isChosen,
                //         onChosen: () {
                //           if (isChosen) {
                //             slotController.selectedDays.remove(day);
                //           } else {
                //             slotController.selectedDays.add(day);
                //           }
                //         },
                //       );
                //     },
                //   ),
                // ),
                //
                // const SizedBox(height: 40),

                // Save button pinned at bottom
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: isSmallScreen(context)
                        ? null : 52,
                      width: isSmallScreen(context)
                          ? displayWidth(context)
                          : displayWidth(context) / 1.4,
                      child: CustomButton(
                        onPressed: slotController.loading.value
                            ? null
                            : () {
                          slotController.saveSlots(
                            availableDays: slotController.selectedDays,
                          );
                        },
                        child: Text(
                          slotController.loading.value ? "Saving..." : "Save",
                          style: TextStyle(
                            fontSize: isSmallScreen(context) ? AppFonts.defaultSize : 18,
                            color: ColorPalette.white,
                          ),
                        ),
                      )),
                ),

                const SizedBox(height: 40),

              ],
            )),
      ),
    );
  }
}
