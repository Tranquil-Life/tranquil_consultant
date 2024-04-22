// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget(
      {Key? key,
        required this.onTimeChosen,
        required this.times,
      }) : super(key: key);

  final Function(String time,int index) onTimeChosen;
  final List times;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final slotController = Get.put(SlotController());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.center,
      child: MyDefaultTextStyle(
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        child:Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 20,
            children: List.generate(
              widget.times.length,
                  (i) {
                var time = widget.times[i];
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.onTimeChosen(time,i);

                        selectedIndex = i;
                      });

                    },
                    child: SizedBox(
                        width: 100,
                        height: 40,
                        child: TimeWidget(
                              text: time,
                              onSelected: ()
                              {
                                if(slotController.timeSlots.contains(time)){
                                  slotController.removeFromSlots(time);
                                }else{
                                  slotController.addToSlots(time);
                                }
                                setState(() {});
                              },
                              selectedSlots: slotController.timeSlots,
                            )
                    )
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


class TimeWidget extends StatelessWidget {
  TimeWidget({
    Key? key,
    required this.text,
    required this.selectedSlots,
    this.onSelected
  })
      : super(key: key);

  final String text;
  Function()? onSelected;
  List selectedSlots;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
          decoration: BoxDecoration(
              color: selectedSlots.contains(text) ? ColorPalette.green : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: selectedSlots.contains(text)
                  ? Border.all(width: 2, color: ColorPalette.white)
                  : null,
              boxShadow: selectedSlots.contains(text) ? [
                BoxShadow(
                    blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
              ] : null
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: selectedSlots.contains(text) ? Colors.white : null),
            ),
          )
      ),
    );
  }
}