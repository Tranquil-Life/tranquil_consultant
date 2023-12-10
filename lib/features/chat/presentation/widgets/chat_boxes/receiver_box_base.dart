import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/reaction_dialog.dart';

class ReceiverChatBoxBase extends StatefulWidget {
  ReceiverChatBoxBase({
    Key? key,
    required this.child,
    required this.time,
    this.padding = 5,
    this.reaction,
    required this.message,
  }) : super(key: key);

  final double padding;
  Widget child;
  final String time;
  String? reaction;
  final Message message;

  @override
  State<ReceiverChatBoxBase> createState() => _ReceiverChatBoxBaseState();
}

class _ReceiverChatBoxBaseState extends State<ReceiverChatBoxBase> {
  String? messageReaction;

  @override
  void initState() {
    super.initState();
    messageReaction = widget.reaction;
  }

  @override
  Widget build(BuildContext context) {
    return ChatBox(
      time: widget.time,
      color: Colors.white,
      reaction: messageReaction,
      swipeRight: true,
      onRelease: (){
        // context.read<ChatBloc>().add(StartReplyMessageEvent(widget.message));
      },
      onReactionTap: () {
        showDialog(
          // backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ReactionDialog(
              child: widget..reaction = messageReaction,
              onEmojiSelected: (category, emoji) {
                Navigator.pop(context);
                setState(() {
                  messageReaction = emoji.emoji;
                });
              },
            ),
          ),
        );
      },
      axisAlignment: CrossAxisAlignment.start,
      child: GestureDetector(
          onLongPress: () {
            showDialog(
              // backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: ReactionDialog(
                    child: widget..reaction = messageReaction,
                    onEmojiSelected: (category, emoji) {
                      Navigator.pop(context);
                      setState(() {
                        messageReaction = emoji.emoji;
                      });
                    }),
              ),
            );
          },
          child: widget.child),
    );
  }
}