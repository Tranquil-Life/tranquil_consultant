import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/text_layout.dart';


class SenderChatText extends StatelessWidget {
  const SenderChatText(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return ChatBox(
      time: message.timeSent ?? 'Sending',
      color: ColorPalette.green,
      axisAlignment: CrossAxisAlignment.end,
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextLayout(message: message),
          ],
        ),
      ),
    );
  }
}