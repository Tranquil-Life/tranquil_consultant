import 'package:flutter/material.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender_box_base.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/voice_note_layout.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';


class SenderChatVoiceNote extends StatelessWidget {
  const SenderChatVoiceNote(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return SenderChatBoxBase(
      time: message.timeSent ?? 'Sending',
      message: message,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoiceNoteLayout(message: message),
        ],
      ),
    );
  }
}