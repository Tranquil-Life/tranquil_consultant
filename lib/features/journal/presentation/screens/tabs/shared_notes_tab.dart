import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

class SharedNotesTab extends StatelessWidget {
  SharedNotesTab({super.key});

  final _ = NotesController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_.sharedNotesList.isEmpty) {
          return Center(
              child: CustomText(
                textAlign: TextAlign.center,
                text: "Your client hasn’t shared a follow-up note with you yet. Notes will appear here once they do.",
                size: AppFonts.baseSize,
              )
          );
        } else {
          return CurrentView(
              view: _.layout.value, notes: _.sharedNotesList, controller: _);
        }
      },
    );
  }
}

class CurrentView extends StatelessWidget {
  const CurrentView({
    Key? key,
    required this.view,
    required this.notes,
    required this.controller,
  }) : super(key: key);

  final String view;
  final List<SharedNote> notes;
  final NotesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: view == grid ? 2 : 1,
          mainAxisSpacing: 57.0,
          crossAxisSpacing: 22.0,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final sharedNote = notes[index];
          return NoteWidget(sharedNote: sharedNote);
        },
        padding: const EdgeInsets.only(bottom: 80), // Add padding to the bottom
      ),
    );
  }
}
