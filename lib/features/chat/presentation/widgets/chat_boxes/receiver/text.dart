import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/text_layout.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class ReceiverChatText extends StatelessWidget {
  const ReceiverChatText(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    String username = "${userDataStore.user['f_name']} ${userDataStore.user['l_name']}";

    return ChatBox(
      time: message.timeSent,
      color: ColorPalette.white,
      axisAlignment: CrossAxisAlignment.start, //positions chatbox to right for sender
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // message.replyMessage != null ? Container(
            //     width: 244,
            //     margin: EdgeInsets.only(bottom: 8),
            //     padding: EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //         color: Color(0xffE1DFDF),
            //         borderRadius: BorderRadius.circular(8.0)
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(message.quoteMessage!.username == username ? "You" : message.quoteMessage!.username!,
            //             style: TextStyle(color: ColorPalette.green)),
            //
            //         Text(
            //           message.quoteMessage!.message!,
            //           style: TextStyle(color: ColorPalette.black.withOpacity(.6)),
            //         ),
            //       ],
            //     )
            // ) : const SizedBox(),

            TextLayout(message: message),
          ],
        ),
      ),
    );
  }
}
