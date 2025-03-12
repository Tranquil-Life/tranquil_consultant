import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/reaction_dialog.dart';

class SenderChatBoxBase extends StatefulWidget {
  SenderChatBoxBase({
    Key? key,
    required this.child,
    this.padding = 5,
    this.time,
    this.reaction='',
    required this.message,
  }) : super(key: key);

  final double padding;
  final Widget child;
  final String? time;
  final Message message;
  String reaction;

  @override
  State<SenderChatBoxBase> createState() => _SenderChatBoxBaseState();
}

class _SenderChatBoxBaseState extends State<SenderChatBoxBase> {
  String messageReaction = '';

  @override
  void initState() {
    super.initState();
    messageReaction = widget.reaction;
  }

  @override
  Widget build(BuildContext context) {
    return ChatBox(
      time: widget.time ?? 'Sending',
      color: ColorPalette.green,
      reaction: messageReaction,
      onRelease: () {
        // context.read<ChatBloc>().add(StartReplyMessageEvent(widget.message));
      },
      onReactionTap: () {
        showDialog(
          // backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ReactionDialog(
                isSender: true,
                child: widget..reaction = messageReaction,
                onEmojiSelected: (category, emoji) {
                  Navigator.pop(context);
                  setState(() {
                    messageReaction = emoji.emoji;
                  });
                }
            ),
          ),
        );
      },
      axisAlignment: CrossAxisAlignment.end,
      child: GestureDetector(
          onLongPress: () {
            showDialog(
              // backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: ReactionDialog(
                    isSender: true,
                    onEmojiSelected: (category, emoji) {
                      Navigator.pop(context);
                      setState(() {
                        messageReaction = emoji.emoji;
                      });
                    },
                    child: widget..reaction = messageReaction
                ),
              ),
            );
          },
          child: widget.child
      ),
    );
  }
}