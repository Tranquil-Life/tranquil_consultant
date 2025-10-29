import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
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
        fontFamily: AppFonts.mulishSemiBold,
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
                  )
                else
                  Expanded(
                      child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 140, // auto-responsiveness
                      mainAxisExtent: 44, // compact, consistent height
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      final isSelected =
                          slotController.timeSlots.contains(slot);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: isSelected ? ColorPalette.green : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: isSelected
                                ? ColorPalette.green
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                              color: Colors.black.withOpacity(0.06),
                            )
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => toggleSelection(slot),
                          child: Center(
                            child: Text(
                              slot,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),

                const SizedBox(height: 16),

                buildDaySelector(),
                const SizedBox(height: 40),

                // Save button pinned at bottom
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: isSmallScreen(context) ? 42 : 46,
                    // was 80 / 120 / 52
                    width: isSmallScreen(context)
                        ? displayWidth(context)
                        : displayWidth(context) / 2,
                    // slightly narrower
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
                          fontSize: isSmallScreen(context) ? 14 : 16,
                          // smaller text
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.white,
                          letterSpacing: .3,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            )),
      ),
    );
  }

  Widget buildDaySelector() {
    final isSmall = isSmallScreen(context);

    final dayList = SizedBox(
      height: isSmall ? 48 : 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final day = days[index];
          final isChosen = slotController.selectedDays.contains(day);
          return DayCard(
            day,
            selected: isChosen,
            onChosen: () {
              if (isChosen) {
                slotController.selectedDays.remove(day);
              } else {
                slotController.selectedDays.add(day);
              }

              setState(() {});
            },
          );
        },
      ),
    );

    // If it's a large screen (tablet/desktop), pin it to bottom center.
    if (!isSmall) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            width: displayWidth(context) / 1.6, // centered narrower width
            child: Center(child: Column(
              children: [
                CustomText(text: "Select work days",
                    color: ColorPalette.grey[600],
                    size: AppFonts.largeSize,
                    fontFamily: AppFonts.mulishSemiBold),

                const SizedBox(height: 16),
                dayList
              ],
            )),
          ),
        ),
      );
    }

    // On small screens, just show it inline as usual.
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          CustomText(text: "Select work days",
              color: ColorPalette.grey[600],
              size: AppFonts.largeSize,
              fontFamily: AppFonts.mulishSemiBold),

          const SizedBox(height: 16),
          dayList
        ],
      ),
    );
  }
}
