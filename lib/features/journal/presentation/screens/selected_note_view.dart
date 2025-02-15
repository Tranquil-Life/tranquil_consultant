// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/shared_note.dart';
import 'package:uuid/uuid.dart';

class NoteView extends StatelessWidget {
  NoteView({super.key, required this.sharedNote});

  final SharedNote sharedNote;
  var uniqueId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffACD5E8),
      appBar: CustomAppBar(
        title: sharedNote.client!.displayName,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sharedNote.note!.mood!.isNotEmpty)
              Hero(
                  tag: 'shared-${sharedNote.note!.mood}-$uniqueId',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      sharedNote.note!.mood!,
                      style: Platform.isIOS
                          ? const TextStyle(fontSize: 48)
                          : const TextStyle(fontSize: 40),
                    ),
                  )),
            Text(
              sharedNote.note!.title,
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 18),
            Text(
              sharedNote.note!.description,
              style: TextStyle(fontSize: AppFonts.defaultSize),
            ),
          ],
        ),
      ),
    );
  }
}
