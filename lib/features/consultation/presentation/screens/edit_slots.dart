import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/day_section_option.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/consultation_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_card.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/day_section_picker.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/time_widget.dart';

class EditSlots extends StatefulWidget {
  const EditSlots({Key? key}) : super(key: key);

  @override
  State<EditSlots> createState() => _EditSlotsState();
}

class _EditSlotsState extends State<EditSlots> {
  final controller = Get.put(ConsultationController());
  ClientUser? clientUser;

  List times = [];
  List selectedDays = [];
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
    getDaySlots();
    super.initState();
  }

  getDaySlots() {
    sortTime(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Availability'),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Stack(
          children: [
            Column(
              children: [
                DaySectionPicker(onDaySelected: (isNightSelected)
                {
                  sortTime(isNightSelected);
                }),

                const SizedBox(height: 48),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TimePickerWidget(
                    onTimeChosen: (newTime, index) {
                      time = newTime;
                    },
                    times: times,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      'Select unavailable days (If any)',
                      style: TextStyle(fontSize: AppFonts.defaultSize, fontFamily: AppFonts.josefinSansSemiBold),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DayCard(
                            day,
                            selected: selectedDays.contains(day),
                            onChosen: (){
                              if(selectedDays.contains(day)){
                                selectedDays.remove(day);
                              }else{
                                selectedDays.add(day);
                              }
                              setState((){});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: Obx(()=> CustomButton(
                        child:  controller.loading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            :const Text("Save", style: TextStyle(fontSize: AppFonts.defaultSize)),
                        onPressed: (){
                          print(controller.listInUtc);
                        })),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  void sortTime(bool isNightHours) {
    if (isNightHours) {
      times = timeOfNightRange();
    } else {
      times = timeOfDayRange();
    }
    setState(() {});
  }

}


