import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/dialogs.dart';

class VoiceNoteDialog extends StatelessWidget {
  final Function()? onPressed;


  const VoiceNoteDialog({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: 'Record a voice note',
      bodyText: 'Voice notes are limited to 1 min. '
          '\n\nYou can opt for audio calls to engage in more extended and in-depth conversations',
      yesDialog: DialogOption(
        'Record',
        onPressed: onPressed,
      ),
    );
  }
}

