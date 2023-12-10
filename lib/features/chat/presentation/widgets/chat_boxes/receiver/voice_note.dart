import 'package:flutter/material.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/receiver_box_base.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/voice_note_layout.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';


class ReceiverChatVoiceNote extends StatelessWidget {
  const ReceiverChatVoiceNote(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    String username = userDataStore.user['f_name'];
    return ReceiverChatBoxBase(
      time: message.timeSent,
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