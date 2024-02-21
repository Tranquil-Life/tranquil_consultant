import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';

class PersonalNoteView2 extends StatelessWidget {
  const PersonalNoteView2({super.key, required this.personalNote});

  final PersonalNote personalNote;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color(int.parse(personalNote.note.hexColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    personalNote.note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: ColorPalette.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 76, 48, 81),
                    ),
                  ),
                ],
              ),
              Text(
                personalNote.note.dateUpdated.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: ColorPalette.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              Expanded(
                child: Text(
                  personalNote.note.description,
                  style: const TextStyle(
                    color: ColorPalette.grey,
                    fontSize: 10,
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalNoteView extends StatelessWidget {
  const PersonalNoteView({super.key, required this.personalNote});

  final PersonalNote personalNote;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color(int.parse(personalNote.note.hexColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    personalNote.note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: ColorPalette.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 76, 48, 81),
                    ),
                  ),
                ],
              ),
              Text(
                personalNote.note.dateUpdated.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: ColorPalette.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              Expanded(
                child: Text(
                  personalNote.note.description,
                  style: const TextStyle(
                    color: ColorPalette.grey,
                    fontSize: 10,
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
