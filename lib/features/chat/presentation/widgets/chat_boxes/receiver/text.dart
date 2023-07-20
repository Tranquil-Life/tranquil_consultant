import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/text_layout.dart';

class ReceiverChatText extends StatelessWidget {
  const ReceiverChatText(this.message, {Key? key}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return ChatBox(
      time: message.timeSent,
      color: ColorPalette.white,
      axisAlignment: CrossAxisAlignment.start, //positions chatbox to right for sender
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: message.parentId!=0,
              child:  Container(
                  width: 244,
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(0xffE1DFDF),
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.displayName ?? "",
                          style: TextStyle(color: ColorPalette.green)),

                      Text(
                        message.parentMessage,
                        style: TextStyle(color: ColorPalette.black.withOpacity(.6)),
                      ),
                    ],
                  )
              ),
            ),

            TextLayout(message: message),
          ],
        ),
      ),
    );
  }
}
