import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({Key? key, required this.note}) : super(key: key);
  final Note note;
  static const _defaultNoteColor = Color(0xFFFDFDFD);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(int.parse(note.hexColor!)) ?? _defaultNoteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  note.dateUpdated?.formatDate ?? '',
                  style: const TextStyle(fontSize: 15, fontFamily: AppFonts.josefinSansRegular),
                ),
              ],
            ),
          ),
          if (note.mood == "")
            SizedBox()
          else
            Positioned(
              bottom: Platform.isIOS ? -8 : -4,
              right: -4,
              child: Container(
                  width: 52,
                  padding: const EdgeInsets.all(4),
                  decoration:  BoxDecoration(
                    color: _defaultNoteColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child:Material(
                      type: MaterialType.transparency,
                      child: Text(
                        note.mood!,
                        style: Platform.isIOS
                            ? const TextStyle(fontSize: 37)
                            : const TextStyle(fontSize: 30),
                      ),
                    ),
                  )
              ),
            ),
        ],
      ),
    );
  }
}
