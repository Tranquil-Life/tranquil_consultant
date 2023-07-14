import 'package:flutter/material.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/image_layout.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender_box_base.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';

class SenderChatImage extends StatelessWidget {
  const SenderChatImage(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return SenderChatBoxBase(
      padding: 3,
      time: message.timeSent,
      message: message,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (message is ReplyMessage)
          //   const Padding(
          //     padding: EdgeInsets.all(2),
          //     child: SenderReplyBox(),
          //   ),
          ChatImageLayout(message: message),
        ],
      ),
    );
  }
}