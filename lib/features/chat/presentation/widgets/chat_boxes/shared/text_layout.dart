import 'package:flutter/material.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';

class TextLayout extends StatelessWidget {
  const TextLayout({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(4), child:  Text(
      message.message!,
      style: TextStyle(color: message.fromYou ? Colors.white : Colors.black),
    ),);
  }
}