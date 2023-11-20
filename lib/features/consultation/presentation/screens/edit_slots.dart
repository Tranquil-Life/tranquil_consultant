import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
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
    controller.getAllSlots();
    getDaySlots();
    super.initState();
  }

  getDaySlots() async{
    sortTime(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Availability'),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Obx(()=>
            Stack(
              children: [
                DaySectionPicker(onDaySelected: (isNightSelected)
                {
                  sortTime(isNightSelected);
                }),

                controller.loading.value ? Center(
                  child: CircularProgressIndicator(color: ColorPalette.green),
                ) :
                Container(
                  height: 400,
                  margin: EdgeInsets.only(top: selectedSection == DaySectionOption.day ? 48 : 18),
                  child: TimePickerWidget(
                    onTimeChosen: (newTime, index) {
                      time = newTime;
                    },
                    times: times,
                  ),
                ),

                controller.loading.value ? Center(child: CircularProgressIndicator(color: ColorPalette.green)) :
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Select available days',
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
                                child: Obx(()=>DayCard(
                                  day,
                                  selected: controller.selectedDays.contains(day),
                                  onChosen: (){
                                    if(controller.selectedDays.contains(day)){
                                      controller.selectedDays.remove(day);
                                    }else{
                                      controller.selectedDays.add(day);
                                    }
                                  },
                                ))
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 48, bottom: 32),
                        child: CustomButton(
                            child: const Text("Save", style: TextStyle(fontSize: AppFonts.defaultSize)),
                            onPressed: (){
                              controller.saveSlots(
                                  availableDays: controller.selectedDays.value
                              );
                            }),
                      )
                    ],
                  ),
                ),

              ],
            )),
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


