import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/shared_note.dart';

class SharedNotesTab extends StatelessWidget {
  SharedNotesTab({Key? key}) : super(key: key);

  final notesController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => CurrentView(
            view: notesController.defaultView.value,
            notes: notesController.sharedNotesList),
      ),
    );
  }
}

class CurrentView extends StatelessWidget {
  const CurrentView({super.key, required this.view, required this.notes});

  final String view;
  final List<SharedNote> notes;

  @override
  Widget build(BuildContext context) {
    return view == grid ? GridState(notes: notes) : Container();
  }
}

class GridState extends StatelessWidget {
  final List<SharedNote> notes;

  const GridState({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 22.0,
        crossAxisSpacing: 22.0,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final sharedNote = notes[index];
        return SharedNoteView(sharedNote: sharedNote);
      },
    );
  }
}
