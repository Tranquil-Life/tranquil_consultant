import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';

class TextLayout extends StatelessWidget {
  const TextLayout({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: CustomText(
        text: message.message!,
        color: message.fromYou ? Colors.white : Colors.black,
        size: AppFonts.defaultSize,
      ),
    );
  }
}
