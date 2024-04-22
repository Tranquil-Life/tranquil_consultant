import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/means_of_id_field.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/text_options_dialog.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({Key? key}) : super(key: key);

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  String formatTextIcon = SvgElements.svgFormatTextIcon;
  String attachIconPath = SvgElements.svgAttachIcon;
  String micIconPath = SvgElements.svgMicIcon;

  NotesController notesController = Get.put(NotesController());
  FocusNode focusNode = FocusNode();

  bool inPreviewMode = false;

  String previewMode = SvgElements.svgPreviewModeIcon;
  String editMode = SvgElements.svgEditModeIcon;

  @override
  void dispose() {
    notesController.titleController.clear();
    notesController.bodyController.clear();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: false,
          title: "New note",
          actions: [
            AppBarAction(
              child: inPreviewMode
                  ? SvgPicture.asset(
                      editMode,
                      color: ColorPalette.white,
                    )
                  : SvgPicture.asset(
                      previewMode,
                      color: ColorPalette.white,
                    ),
              onPressed: () => setState(() => inPreviewMode = !inPreviewMode),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      maxLines: 1,
                      controller: notesController.titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Expanded(
                        child: inPreviewMode
                            ? RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: parseNoteText(
                                      notesController.bodyController.text),
                                ),
                              )
                            : TextField(
                                style: TextStyle(
                                    fontWeight: notesController.isBold.value
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                                controller: notesController.bodyController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: "What are your thoughts?",
                                  border: InputBorder.none,
                                ),
                              ))),
                  ],
                ),
                Positioned(
                    bottom: 50,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 64,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.black12,
                              offset: Offset(3, 6)),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 20,
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (notesController
                                            .bodyController.selection !=
                                        null) {
                                      openTextOptionsDialog(context);
                                    } else {
                                      CustomSnackBar.showSnackBar(
                                          context: context,
                                          title: "Highlight a text",
                                          message:
                                              "highlight the text you want to format",
                                          backgroundColor: ColorPalette.blue);
                                    }
                                  },
                                  child: editOptionItem(formatTextIcon),
                                ),
                                editOptionItem(attachIconPath, width: 24),
                                editOptionItem(micIconPath, width: 24),
                              ],
                            ),
                            SizedBox(
                              width: 137,
                              child: CustomButton(
                                onPressed: () async =>
                                    await notesController.createNote(),
                                text: "Save note",
                              ),
                            )
                          ]),
                    ))
              ],
            )),
      ),
    );
  }

  editOptionItem(String icon, {double? width}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(4)),
      child: Center(
          child: SvgPicture.asset(
        icon,
        width: width,
        color: ColorPalette.black,
      )),
    );
  }
}
