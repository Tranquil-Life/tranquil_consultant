import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/create_note.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

class PersonalNotesTab extends StatefulWidget {
  const PersonalNotesTab({super.key});

  @override
  State<PersonalNotesTab> createState() => _PersonalNotesTabState();
}

class _PersonalNotesTabState extends State<PersonalNotesTab> {
  final _ = Get.put(NotesController());

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
        Obx(
          () => CurrentView(
              layout: _.layout.value,
              notes: _.personalNotesList,
              controller: _),
        ),
        Positioned(
          right: 25,
          bottom: 50,
          child: FloatingActionButton(
            backgroundColor: ColorPalette.green,
            onPressed: () {
              Get.to(const CreateNote());
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
          childAspectRatio: 1,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        itemCount: notes.length,
        shrinkWrap: true,
        controller: controller.scrollController,
        padding: const EdgeInsets.only(bottom: 40), // Add padding to the bottom
        itemBuilder: (context, index) => NoteWidget(
          personalNote: notes[index],
        ),));
  }
}
