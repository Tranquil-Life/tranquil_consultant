import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
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

  List times = [];
  String? time;

  DateTime? dateTime = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');
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

  @override
  void initState() {
    slotController.timeSlots.clear();
    slotController.getAllSlots();
    getDaySlots();
    super.initState();
  }

  getDaySlots() async {
    sortTime(false);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              DaySectionPicker(onDaySelected: (isNightSelected) {
                sortTime(isNightSelected);
              }),
              Obx(
                () => slotController.loading.value
                    ? const CircularProgressIndicator(color: ColorPalette.green)
                    : Container(
                        height: 250,
                        margin: EdgeInsets.only(
                            bottom: 70,
                            top: selectedSection == DaySectionOption.day
                                ? 48
                                : 18),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          alignment: Alignment.center,
                          child: MyDefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            child: Center(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 20,
                                children: List.generate(
                                  times.length,
                                  (i) {
                                    var time = times[i];
                                    return GestureDetector(
                                        onTap: () {
                                          if (slotController.timeSlots
                                              .contains(time))
                                          {
                                            slotController.timeSlots
                                                .remove(time);
                                          } else {
                                            slotController.timeSlots.add(time);
                                          }
                                        },
                                        child: SizedBox(
                                            width: 100,
                                            height: 40,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: slotController
                                                          .timeSlots
                                                          .contains(time)
                                                      ? Colors.green
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  border: slotController
                                                          .timeSlots
                                                          .contains(time)
                                                      ? Border.all(
                                                          width: 2,
                                                          color: ColorPalette
                                                              .white)
                                                      : null,
                                                  boxShadow: slotController
                                                          .timeSlots
                                                          .contains(time)
                                                      ? [
                                                          BoxShadow(
                                                              blurRadius: 6,
                                                              color: Colors
                                                                  .black12,
                                                              offset:
                                                                  Offset(0, 3)),
                                                        ]
                                                      : null),
                                              child: Center(
                                                child: Text(time.toString(),
                                                    style: TextStyle(
                                                        color: slotController
                                                                .timeSlots
                                                                .contains(time)
                                                            ? Colors.white
                                                            : null)),
                                              ),
                                            )

                                            // TimeWidget(
                                            //   text: time,
                                            //   onSelected: ()Ò
                                            //   {
                                            //     //before selection
                                            //     print("BEFORE SELECTION ${slotController.timeSlots}");
                                            //     if(slotController.timeSlots.contains(time)){
                                            //       print("ARRAY CONTAINS: $time");
                                            //
                                            //       slotController.removeFromSlots(time);
                                            //
                                            //       print("ITEM REMOVED FROM SELECTION ${slotController.timeSlots}");
                                            //
                                            //     }else{
                                            //       print("ARRAY DOESN'T CONTAIN: $time");
                                            //
                                            //       slotController.addToSlots(time);
                                            //
                                            //       print("ITEM ADDED TO SELECTION ${slotController.timeSlots}");
                                            //
                                            //     }
                                            //     setState(() {});
                                            //   },
                                            //   selectedSlots: slotController.timeSlots,
                                            // )
                                            ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        )

                        // TimePickerWidget(
                        //   onTimeChosen: (newTime, index) {
                        //     time = newTime;
                        //   },
                        //   times: times,
                        // ),
                        ),
              ),
              Obx(
                () => slotController.loading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: ColorPalette.green))
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 24),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: DayCard(
                                        day,
                                        selected: slotController.selectedDays
                                            .contains(day),
                                        onChosen: () {
                                          if (slotController.selectedDays
                                              .contains(day)) {
                                            slotController.selectedDays
                                                .remove(day);
                                          } else {
                                            slotController.selectedDays
                                                .add(day);
                                          }
                                          setState(() {});
                                        },
                                      ));
                                },
                              ),
                            ),

                            //save button
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 48, bottom: 32),
                              child: CustomButton(
                                  child: const Text("Save",
                                      style: TextStyle(
                                          fontSize: AppFonts.defaultSize,
                                          color: ColorPalette.white)),
                                  onPressed: () {
                                    slotController.saveSlots(
                                        availableDays:
                                            slotController.selectedDays);
                                  }),
                            )
                          ],
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sortTime(bool isNightHours) {
    if (isNightHours) {
      times = timeOfNightRange();
      selectedSection = DaySectionOption.night;
    } else {
      times = timeOfDayRange();
      selectedSection = DaySectionOption.day;
    }
    setState(() {});
  }
}
