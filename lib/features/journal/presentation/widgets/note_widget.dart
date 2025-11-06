// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/dialogs.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/properties.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/create_note.dart';

class NoteWidget extends StatelessWidget {
  NoteWidget({super.key, this.sharedNote, this.personalNote});

  final PersonalNote? personalNote;
  final SharedNote? sharedNote;

  final notesController = NotesController.instance;

  String attachIcon = SvgElements.svgAttachIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: personalNote == null
            ? (sharedNote!.note == null
                ? null
                : () async {
                    //..
                  })
            : () async {
                await showModalBottomSheet(
                    context: context,
                    barrierColor: Colors.black26,
                    backgroundColor: Colors.transparent,
                    builder: (_) =>
                        NoteBottomSheet(personalNote: personalNote));
              },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: personalNote == null
                      ? sharedNote!.note == null
                          ? ColorPalette.grey
                          : Color(int.parse(sharedNote!.note!.hexColor))
                      : ColorPalette.pNoteBgColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    const BoxShadow(
                        blurRadius: 6,
                        color: Colors.black12,
                        offset: Offset(0, 3))
                  ]),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: personalNote == null
                      ?
                      //Shared Notes
                      (sharedNote!.note == null
                          ? const Center(
                              child: Text(
                                  "This note has been deleted by the client"),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => SizedBox(
                                        width:
                                            notesController.layout.value == grid
                                                ? 148 / 2
                                                : 148,
                                        child: Text(
                                          truncateString(
                                            notesController.layout.value,
                                            sharedNote!.note!.title,
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            color: ColorPalette.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.more_vert,
                                      color: Color.fromARGB(255, 76, 48, 81),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  sharedNote!.note!.dateUpdated!.formatDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                    color: ColorPalette.pNoteBodyTxtColor,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Expanded(
                                  child: Text(
                                    sharedNote!.note!.description,
                                    style: const TextStyle(
                                      color: ColorPalette.pNoteBodyTxtColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ))

                      ///Personal notes
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => SizedBox(
                                    width: notesController.layout.value == grid
                                        ? 148 / 1.4
                                        : 148,
                                    child: Text(
                                      truncateString(
                                          notesController.layout.value,
                                          personalNote!.heading),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: ColorPalette.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.more_vert,
                                  color: Color.fromARGB(255, 76, 48, 81),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              personalNote!.updatedAt!.formatDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                                color: ColorPalette.pNoteBodyTxtColor,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: parseNoteText(personalNote!.body),
                                ),
                              ),
                              // Text(
                              //   personalNote!.body,
                              //   style: const TextStyle(
                              //     color: ColorPalette.pNoteBodyTxtColor,
                              //     fontSize: 12,
                              //   ),
                              // ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  personalNote!.isFavourite == true
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: const Color.fromARGB(255, 76, 48, 81),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text(personalNote!.attachments!.length
                                          .toString()),
                                      SizedBox(width: 4),
                                      SvgPicture.asset(attachIcon),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
            ),
            sharedNote != null && sharedNote!.client != null
                ? Positioned(
                    bottom: -50,
                    right: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                    color: ColorPalette.green[100],
                                    border: Border.all(
                                        width: 2, color: ColorPalette.grey),
                                    borderRadius: BorderRadius.circular(28)),
                                child: Center(
                                  child: UserAvatar(
                                    imageUrl: sharedNote!.client!.avatarUrl,
                                    source: sharedNote!.client!.usesBitmoji!
                                        ? AvatarSource.bitmojiUrl
                                        : AvatarSource.url,
                                  ),
                                )),
                            SizedBox(width: 4),
                            Text(sharedNote!.client!.displayName)
                          ],
                        ),
                        Text(
                          sharedNote!.note!.mood!,
                          style: Platform.isIOS
                              ? const TextStyle(fontSize: 32)
                              : const TextStyle(fontSize: 25),
                        ),
                      ],
                    ))
                : SizedBox(),
          ],
        ));
  }

  String truncateString(String layout, String input) {
    if (layout == grid) {
      int maxLength = 10;
      if (input.length > maxLength) {
        return '${input.substring(0, maxLength)}...';
      } else {
        return input;
      }
    } else {
      int maxLength = 20;
      if (input.length > maxLength) {
        return '${input.substring(0, maxLength)}...';
      } else {
        return input;
      }
    }
  }
}

class NoteBottomSheet extends StatelessWidget {
  final PersonalNote? personalNote;
  final SharedNote? sharedNote;

  bool isMultiple = false;

  NoteBottomSheet({super.key, this.personalNote, this.sharedNote});

  // NotesController notesController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    // isMultiple = notes.length > 1;
    return Container(
        padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
        decoration: bottomSheetDecoration,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Option(
                label: 'View Note',
                icon: const Icon(Icons.remove_red_eye_outlined),
                onPressed: () async {
                  if (personalNote != null) {
                    await Get.to(
                      const CreateNote(),
                      arguments: {'personal_note': personalNote},
                    );
                  } else {
                    await Get.to(
                      const CreateNote(),
                      arguments: {'shared_note': sharedNote},
                    );
                  }
                },
              ),
              // const SizedBox(height: 4),
              // _Option(
              //   label: 'Add to favorites',
              //   icon: const Icon(Icons.star_border_outlined),
              //   onPressed: () {
              //     //..
              //   },
              // ),
              // const SizedBox(height: 4),
              //
              // if(sharedNote == null)
              // _Option(
              //   label: 'Delete note',
              //   icon: const Icon(Icons.delete_outline),
              //   onPressed: () {
              //     Get.back();
              //
              //     // return showDialog(
              //     //     context: context,
              //     //     builder: (_) => ConfirmDialog(
              //     //         title: 'Are you sure?',
              //     //         bodyText:
              //     //             '${isMultiple ? 'These notes' : 'This note'} will be permanently deleted.',
              //     //         yesDialog: DialogOption(
              //     //           'Delete',
              //     //           onPressed: () async {
              //     //             // await notesController.deleteNote([note]);
              //     //           },
              //     //         )));
              //   },
              // ),
            ],
          ),
        ));
  }
}

class _Option extends StatelessWidget {
  const _Option({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final Widget icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Flexible(
              child: Text(label, style: const TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
