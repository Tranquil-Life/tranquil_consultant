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
import 'package:tl_consultant/features/consultation/presentation/widgets/day_section_picker.dart';
import 'package:tl_consultant/features/consultation/presentation/widgets/time_widget.dart';
import 'package:velocity_x/velocity_x.dart';

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

  @override
  void initState() {
    getDatSlots();
    super.initState();
  }

  getDatSlots() {
    //await Future.delayed(Duration(seconds: 1));
    sortTime(false);
    //times = timeOfDayRange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Availability'),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          children: [
            Column(
              children: [
                DaySectionPicker(onDaySelected: (isNightSelected)
                {
                  setState(() {
                    if(isNightSelected){
                      //..
                    }else{
                    }
                  });
                  sortTime(isNightSelected);
                }),

                const SizedBox(height: 48),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TimePickerWidget(
                    onTimeChosen: (newTime, index) {
                      time = newTime;
                      controller.selectedTime.value = time!;
                    },
                    times: times,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

              ],
            ),

            Obx(()=> CustomButton(
                child:  controller.loading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    :const Text("Save", style: TextStyle(fontSize: AppFonts.defaultSize)),
                onPressed: (){
                 //..
                }))
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
