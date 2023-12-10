import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/text_layout.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';


class SenderChatText extends StatelessWidget {
  const SenderChatText(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    String username = "${userDataStore.user['f_name']} ${userDataStore.user['l_name']}";

    return ChatBox(
      time: message.timeSent ?? 'Sending',
      color: ColorPalette.green,
      axisAlignment: CrossAxisAlignment.end, //positions chatbox to right for sender
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.parentId != null
                ?
            Container(
                width: 244,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: ColorPalette.green[800],
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: const SizedBox()
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(message.replyMessage!.username == username ? "You" : message.replyMessage!.username!,
              //         style: TextStyle(color: ColorPalette.green[200])),
              //
              //     Text(
              //       message.replyMessage!.message!,
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //   ],
              // )
            )
                : const SizedBox(),

            //the message
            TextLayout(message: message),
          ],
        ),
      ),
    );
  }
}