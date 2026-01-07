import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/means_of_id_field.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/text_options_dialog.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final notesController = NotesController.instance;
  final dashboardController = DashboardController.instance;

  String formatTextIcon = SvgElements.svgFormatTextIcon;
  String attachIconPath = SvgElements.svgAttachIcon;
  String micIconPath = SvgElements.svgMicIcon;

  FocusNode focusNode = FocusNode();
  bool inPreviewMode = false;
  bool isAlreadySaved = false;
  String previewMode = SvgElements.svgPreviewModeIcon;
  String editMode = SvgElements.svgEditModeIcon;
  PersonalNote? personalNote;
  SharedNote? sharedNote;
  String mood = "";

  @override
  void initState() {
    var data = Get.arguments;
    if (data != null) {
      Map args = data as Map;
      if (args['personal_note'] != null) {
        personalNote = args['personal_note'];

        notesController.titleController.text = personalNote!.heading;
        notesController.bodyController.text = personalNote!.body;

        isAlreadySaved = true;
      } else if (args['shared_note'] != null) {
        sharedNote = args['shared_note'];
        mood = sharedNote!.note!.mood!;
        // bgColor = Color(int.parse(sharedNote!.hexColor!));
      }
    }

    super.initState();
  }

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
        backgroundColor: Colors.grey.shade100,
        appBar: CustomAppBar(
          centerTitle: false,
          title: sharedNote == null
              ? isAlreadySaved
                  ? "Edit note"
                  : "New note"
              : "View note",
          onBackPressed: () async {
            if (Get.key.currentState?.canPop() ?? false) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.DASHBOARD); // fallback route
              await Future.delayed(const Duration(milliseconds: 500));
              dashboardController.currentIndex.value = 1;
            }
          },
          actions: [
            AppBarAction(
              actionBgColor: ColorPalette.green,
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
                                  hintText: "What's on your mind?",
                                  border: InputBorder.none,
                                ),
                              ))),
                  ],
                ),
                if (!isAlreadySaved)
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
                                        CustomSnackBar.neutralSnackBar(
                                            title: "Highlight a text",
                                            "highlight the text you want to format");
                                      }
                                    },
                                    child: editOptionItem(formatTextIcon),
                                  ),
                                  editOptionItem(attachIconPath,
                                      width: 24, color: ColorPalette.grey),
                                  editOptionItem(micIconPath,
                                      width: 24, color: ColorPalette.grey),
                                ],
                              ),
                              SizedBox(
                                width: 137,
                                child: CustomButton(
                                  onPressed: () async {
                                    if (!isAlreadySaved) {
                                      await notesController.createNote();
                                    } else {
                                      //...update
                                    }
                                  },
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

  editOptionItem(String icon, {double? width, Color? color}) {
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
        color: color ?? ColorPalette.black,
      )),
    );
  }
}
