import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/create_newnote_screen.dart';
import 'package:tl_consultant/features/journal/presentation/screens/shared_note.dart';

class PersonalNotesTab extends StatelessWidget {
  PersonalNotesTab({Key? key}) : super(key: key);

  final notesController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorPalette.green,
        onPressed: () {
          Get.to(const NewNote());
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => CurrentView(
            view: notesController.defaultView.value,
            notes: notesController.personalNotesList),
      ),
    );
  }
}

class CurrentView extends StatelessWidget {
  const CurrentView({super.key, required this.view, required this.notes});

  final String view;
  final List<PersonalNote> notes;

  @override
  Widget build(BuildContext context) {
    return view == grid ? GridState(notes: notes) : ListState(notes: notes);
  }
}

class GridState extends StatelessWidget {
  final List<PersonalNote> notes;
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
        final PersonalNote = notes[index];
        print(notesController.sharedNotesList);
        return PersonalNoteView(
          personalNote: PersonalNote,
        );
      },
    );
  }
}

class ListState extends StatelessWidget {
  final List<PersonalNote> notes;
  final notesController = Get.put(NotesController());
  ListState({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final PersonalNote personalNote = notes[index];
        print(notesController.sharedNotesList);
        return PersonalNoteView(
          personalNote: personalNote,
        );
      },
    );
  }
}
