import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';

class SharedNoteView extends StatelessWidget {
  const SharedNoteView({super.key, required this.sharedNote});

  final SharedNote sharedNote;
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
        color: Color(int.parse(sharedNote.note.hexColor)),
      ),
    );
  }
}



/**
 * 
 * 
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    sharedNote.note.title,
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
                sharedNote.note.dateUpdated.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: ColorPalette.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              Expanded(
                child: Text(
                  sharedNote.note.description,
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
     
 */