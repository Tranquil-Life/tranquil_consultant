import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
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
    return view == grid ? GridState(notes: notes) : ListState(notes: notes);
  }
}

class GridState extends StatelessWidget {
  final List<SharedNote> notes;
  final notesController = Get.put(NotesController());
  GridState({super.key, required this.notes});

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
        print(notesController.sharedNotesList);
        return SharedNoteView(sharedNote: sharedNote);
      },
    );
  }
}

class ListState extends StatelessWidget {
  final List<SharedNote> notes;
  final notesController = Get.put(NotesController());
  ListState({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final SharedNote sharedNote = notes[index];
        print(notesController.sharedNotesList);
        return SharedNoteView2(
          sharedNote: sharedNote,
        );
      },
    );
  }
}
