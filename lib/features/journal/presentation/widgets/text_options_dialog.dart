import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

class TextOptionsDialog extends StatefulWidget {
  const TextOptionsDialog({super.key});

  @override
  _TextOptionsDialogState createState() => _TextOptionsDialogState();
}

class _TextOptionsDialogState extends State<TextOptionsDialog> {
  NotesController notesController = Get.put(NotesController());

  bool _isItalic = false;
  bool _isBold = false;

  String formatTextIcon = SvgElements.svgFormatTextIcon;
  //format text options var
  String italicsIcon = SvgElements.svgItalicsIcon;
  String boldIcon = SvgElements.svgBoldIcon;

  void applyStyle({TextStyle? style, String? startTag, String? endTag}) {
    final String text = notesController.bodyController.text;
    final TextSelection selection = notesController.bodyController.selection;
    final int start = selection.start;
    final int end = selection.end;

    if (text.contains('**${text.substring(start, end)}**') &&
        style == const TextStyle(fontStyle: FontStyle.italic)) {
      final List<String> words = text.substring(start, end).split(' ');

      final String formattedText = words.map((word) {
        return '$startTag$word$endTag';
      }).join(' ');

      final String newText =
          text.replaceRange(start - 2, end + 2, formattedText);

      setState(() {
        notesController.bodyController.value =
            notesController.bodyController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(
              offset: end + startTag!.length + endTag!.length),
        );
      });
    } else {
      // Split the selected text into words
      final List<String> words = text.substring(start, end).split(' ');

      // Format each word individually and join them back together
      final String formattedText = words.map((word) {
        return '$startTag$word$endTag';
      }).join(' ');

      final String newText = text.replaceRange(start, end, formattedText);

      setState(() {
        notesController.bodyController.value =
            notesController.bodyController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(
              offset: end + startTag!.length + endTag!.length),
        );
      });
    }
  }

  void toggleBold() {
    applyStyle(
      style: TextStyle(fontWeight: FontWeight.bold),
      startTag: '**',
      endTag: '**',
    );
  }

  void toggleItalic() {
    applyStyle(
      style: TextStyle(fontStyle: FontStyle.italic),
      startTag: '_',
      endTag: '_',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            top: -40,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.cancel_rounded,
                size: 26.67,
                color: ColorPalette.white,
              ),
            )),
        Container(
          height: displayHeight(context) * 0.4,
          padding: EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 40),
          width: displayWidth(context),
          decoration: BoxDecoration(
              color: ColorPalette.white,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    formatTextIcon,
                    width: 24,
                  ),
                  SizedBox(width: 12),
                  const Text(
                    "Text Options",
                    style: TextStyle(
                      color: ColorPalette.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "Choose text option to apply to text",
                    style: TextStyle(fontSize: 12, color: Color(0xFF808080)),
                  )),
              Wrap(
                direction: Axis.vertical,
                spacing: 20,
                children: [
                  textOptionWidget(
                    italicsIcon,
                    "Italics text",
                    _isItalic,
                    onTap: (val) {
                      setState(() {
                        _isItalic = !_isItalic;
                        _isBold = false;
                      });
                    },
                  ),
                  textOptionWidget(
                    boldIcon,
                    "Bold text",
                    _isBold,
                    onTap: (val) {
                      setState(() {
                        _isBold = !_isBold;
                        _isItalic = false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: ColorPalette.green,
                            ),
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onPressed: () {
                        Get.back();
                        // Functionality for the first button
                      },
                      child: const Text(
                        'Cancel',
                        style:
                            TextStyle(color: ColorPalette.green, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            if (_isBold) {
                              toggleBold();
                            } else if (_isItalic) {
                              toggleItalic();
                            }

                            Get.back();
                            // Functionality for the second button
                          },
                          child: const Text(
                            'Apply option',
                            style: TextStyle(
                                color: ColorPalette.white, fontSize: 16),
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget textOptionWidget(String icon, String name, bool selected,
      {required Function(bool) onTap, double? width}) {
    return GestureDetector(
      onTap: () {
        onTap(!selected); // Toggle the boolean value
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: selected ? ColorPalette.green : ColorPalette.white,
              border: Border.all(color: Color(0xffD4D4D4), width: 1.5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: selected
                  ? Icon(
                      Icons.check,
                      color: ColorPalette.white,
                      size: 16,
                    )
                  : SizedBox(),
            ),
          ),
          SizedBox(width: 12),
          SvgPicture.asset(
            icon,
            width: width,
            color: ColorPalette.black,
          ),
          SizedBox(width: 4),
          Text(name)
        ],
      ),
    );
  }
}

openTextOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero, content: TextOptionsDialog()),
  );
}
