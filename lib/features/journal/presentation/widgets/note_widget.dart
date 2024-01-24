import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({Key? key, required this.sharedNote}) : super(key: key);
  final SharedNote sharedNote;
  static const _defaultNoteColor = Color(0xFFFDFDFD);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffACD5E8),
        // color: Color(int.parse(sharedNote.note.hexColor!)) ?? _defaultNoteColor,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        color: Color(0xffB4E5BC),
                        child: UserAvatar(
                          imageUrl: sharedNote.client.avatarUrl,
                          source: sharedNote.client.usesBitmoji!
                              ? AvatarSource.bitmojiUrl
                              : AvatarSource.url,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          sharedNote.client.displayName,
                          style: TextStyle(
                              color: ColorPalette.green[800],
                              fontSize: AppFonts.defaultSize),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: SizedBox(
                        height: 10,
                        child: Text(
                          sharedNote.note.title.length > 18
                              ? "${sharedNote.note.title.substring(0, 18)}..."
                              : sharedNote.note.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.josefinSansRegular,
                          ),
                        ))),
                Text(
                  sharedNote.note.dateUpdated?.formatDate ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.josefinSansRegular,
                  ),
                ),
                SizedBox(height: 4)
              ],
            ),
          ),
          Positioned(
            bottom: Platform.isIOS ? -8 : -4,
            right: -4,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
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
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    sharedNote.note.mood!,
                    style: Platform.isIOS
                        ? const TextStyle(fontSize: 37)
                        : const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
