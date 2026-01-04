import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/create_note.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

class PersonalNotesTab extends StatefulWidget {
  const PersonalNotesTab({super.key});

  @override
  State<PersonalNotesTab> createState() => _PersonalNotesTabState();
}

class _PersonalNotesTabState extends State<PersonalNotesTab> {
  final _ = NotesController.instance;


  @override
  void initState() {
    _.scrollController = ScrollController()
      ..addListener(() => _.loadMorePersonalNotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (_.personalNotesList.isEmpty) {
            return Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: AppFonts.baseSize),
                  children: [
                    TextSpan(text: "You don’t have any notes yet. Tap the ", style: TextStyle(fontFamily: AppFonts.mulishRegular)),
                    TextSpan(
                      text: "+",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " button to create your first one.", style: TextStyle(fontFamily: AppFonts.mulishRegular)),
                  ],
                ),
              )
            );
          } else {
            return CurrentView(
                layout: _.layout.value,
                notes: _.personalNotesList,
                controller: _);
          }
        }),
        Positioned(
          right: 25,
          bottom: 50,
          child: FloatingActionButton(
            heroTag: "personal_notes_fab",
            // Unique tag to avoid conflicts
            shape: CircleBorder(),
            backgroundColor: ColorPalette.green,
            onPressed: () async{
              var isEmpty = await checkForEmptyProfileInfo();
              if(isEmpty){
                Get.toNamed(Routes.EDIT_PROFILE);
              }else{
                Get.toNamed(Routes.CREATE_NOTE);// Navigate to create note screen
              }
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentView extends StatelessWidget {
  const CurrentView(
      {super.key,
      required this.layout,
      required this.notes,
      required this.controller});

  final String layout;
  final List<PersonalNote> notes;
  final NotesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout == grid ? 2 : 1,
            childAspectRatio: 0.85,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          itemCount: notes.length,
          shrinkWrap: true,
          controller: controller.scrollController,
          padding: const EdgeInsets.only(bottom: 40),
          // Add padding to the bottom
          itemBuilder: (context, index) => NoteWidget(
            personalNote: notes[index],
          ),
        ));
  }
}
