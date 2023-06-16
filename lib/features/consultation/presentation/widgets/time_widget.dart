import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/core/utils/helpers/day_section_option.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/consultation_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class TimePickerWidget extends StatefulWidget {
  TimePickerWidget(
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
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.center,
      child: MyDefaultTextStyle(
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Center(
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
                          // if(widget.currentDayOption == DaySectionOption.day){
                          //   widget.initialDayOption = DaySectionOption.day;
                          // }else{
                          //   widget.initialDayOption = DaySectionOption.night;
                          // }
                        });

                      },
                      child: SizedBox(
                        width: 100,
                        height: 40,
                        child: TimeWidget(
                          text: time,
                          // isSelected: ConsultationController.instance.daySectionStatus
                          //   (widget.initialDayOption, widget.currentDayOption, selectedIndex) == i,
                        ),
                      )
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({Key? key, required this.text, this.isSelected = false})
      : super(key: key);

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child:  Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : null),
      ),
    )
        .rounded.p8
        .alignCenter
        .neumorphic(
        color: isSelected ? ColorPalette.green : Colors.white,
        elevation: 12,
        curve: VxCurve.emboss
    ).make();
  }
}