import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';

class TherapistTypeItem extends StatelessWidget {
  const TherapistTypeItem({super.key, required this.onTap, required this.bgColor, required this.iconColor, required this.radioFillColor, required this.radioValue, required this.radioGroupValue, this.headingTextColor, required this.heading, required this.body, this.bodyTextColor, required this.icon});

  final Function() onTap;
  final Color bgColor;
  final Color? iconColor;
  final Color? headingTextColor;
  final Color? bodyTextColor;
  final WidgetStateProperty<Color?> radioFillColor;
  final String radioValue;
  final String radioGroupValue;
  final String heading;
  final String body;
  final String icon;
  // controller.selectedType(solo);
  //controller.selectedType.value == solo
  //               ? ColorPalette.green.shade100
  //               : ColorPalette.white

  //MaterialStateProperty.resolveWith<Color>(
  //                         (Set<MaterialState> states) {
  //                       return (controller.selectedType.value ==
  //                           solo)
  //                           ? ColorPalette.green
  //                           : ColorPalette.gray.shade200;
  //                     }),

  //controller.selectedType.value

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 89,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        width: displayWidth(context),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
              width: 1, color: ColorPalette.gray.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(
                      icon,
                      color: iconColor, // Replace 'iconColor' with the desired color (e.g., Colors.red)
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          heading,
                          style: TextStyle(
                            color: headingTextColor,
                            fontSize: AppFonts.baseSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          body,
                          style: TextStyle(
                            color: bodyTextColor,
                            fontSize: AppFonts.defaultSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
                fillColor: radioFillColor,
                value: radioValue,
                activeColor: ColorPalette.green,
                groupValue: radioGroupValue,
                onChanged: null)
          ],
        ),
      ),
    );
  }
}
