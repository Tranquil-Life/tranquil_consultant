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
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_card.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_section_picker.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/time_widget.dart';

class EditSlots extends StatefulWidget {
  const EditSlots({Key? key}) : super(key: key);

  @override
  State<EditSlots> createState() => _EditSlotsState();
}

class _EditSlotsState extends State<EditSlots> {
  final slotController = Get.put(SlotController());
  ClientUser? clientUser;

  DaySectionOption? selectedSection;

  List days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  List<String> timeSlots = [];
  List<String> selectedSlots = [];

  @override
  void initState() {
    super.initState();
    slotController.getAllSlots();
    timeSlots = generateTimeSlots(startHour: 6, endHour: 18, intervalMinutes: 60);
  }

  /// Toggles the selection of a time slot
  void toggleSelection(String slot) {
    if (slotController.timeSlots.contains(slot)) {
      slotController.timeSlots.remove(slot);
    } else {
      slotController.timeSlots.add(slot);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.grey[200],
        title: 'Edit Availability',
      ),
      backgroundColor: Colors.grey[200],
      body: Obx((){
        selectedSlots = List<String>.from(slotController.timeSlots);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Column(
            children: [
              DaySectionPicker(
                  onDaySelected: (isNightSelected) {
                    sortTime(isNightSelected);

                    setState(() {});
                  }),
              const SizedBox(height: 32),

              Expanded(
                child:  slotController.loading.value ? Center(child: CircularProgressIndicator(color: ColorPalette.green)) : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final slot = timeSlots[index];
                    final isSelected = selectedSlots.contains(slot);
                    return GestureDetector(
                      onTap: () => toggleSelection(slot),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            slot,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                  flex: 1,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24, top: 24),
                        child: Text(
                          'Select available days',
                          style: TextStyle(
                              fontSize: AppFonts.defaultSize,
                              fontFamily: AppFonts.josefinSansSemiBold),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          itemCount: days.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(right: 16),
                          itemBuilder: (_, index) {
                            final day = days[index];
                            return Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                                child: DayCard(
                                  day,
                                  selected:
                                  slotController.selectedDays.contains(day),
                                  onChosen: () {
                                    if (slotController.selectedDays
                                        .contains(day)) {
                                      slotController.selectedDays.remove(day);
                                    } else {
                                      slotController.selectedDays.add(day);
                                    }
                                    setState(() {});
                                  },
                                ));
                          },
                        ),
                      ),


                      //save button
                      Padding(
                        padding: const EdgeInsets.only(top: 48, bottom: 32),
                        child: CustomButton(
                            child: const Text("Save",
                                style: TextStyle(
                                    fontSize: AppFonts.defaultSize,
                                    color: ColorPalette.white)),
                            onPressed: () {
                              slotController.saveSlots(
                                  availableDays: slotController.selectedDays);
                            }),
                      )
                    ],
                  ))
            ],
          ),
        );
      }),
    );
  }

  void sortTime(bool isNightHours) {
    timeSlots.clear();
    if (isNightHours) {
      selectedSection = DaySectionOption.night;
      timeSlots = generateTimeSlots(startHour: 19, endHour: 22, intervalMinutes: 60);

    } else {
      selectedSection = DaySectionOption.day;
      timeSlots = generateTimeSlots(startHour: 6, endHour: 18, intervalMinutes: 60);
    }
  }
}
