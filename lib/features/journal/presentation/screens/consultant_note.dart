import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/create_note_screen.dart';

class ConsultantNote extends StatelessWidget {
  const ConsultantNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NotesController noteController = Get.find();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorPalette.green,
        onPressed: () async {
          await Get.to(const NewNote());
        },
        child: const Icon(
          Icons.add,
          color: ColorPalette.white,
        ),
      ),
      body: Obx(
        () => Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: noteController.notes.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noteController.notes[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        noteController.notes[index].note,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
