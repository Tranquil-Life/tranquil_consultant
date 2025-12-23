import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_player_manager.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/message_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/voice_bubble.dart';

class Messages extends StatefulWidget {
  const Messages({super.key, required this.scroll, required this.pmFeed});

  final ScrollController scroll;
  final AudioPlayerManager pmFeed;


  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages>{
  final chatController = ChatController.instance;
  final messageController = MessageController.instance;

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      // Make a safe copy and sort descending (newest first)
      final messages = [...chatController.messages];
      messages
          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      // Update the recent message event
      if (messages.isNotEmpty) {
        chatController.recentMsgEvent.value = messages.first;
      }

      final showLoader = chatController.isLoadMoreRunning.value;
      final totalCount = messages.length + (showLoader ? 1 : 0);

      return ListView.builder(
        controller: widget.scroll,
        physics: const BouncingScrollPhysics(),
        reverse: true,
        // so new messages appear at the bottom
        padding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 12)
            .add(const EdgeInsets.only(bottom: 72)),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          // Loader at top (because reverse:true)
          if (showLoader && index == messages.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorPalette.green,
                  ),
                ),
              ),
            );
          }

          final msg = messages[index];
          final fromMe = (msg.senderId == myId &&
              msg.senderType == consultant);
          final align = fromMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start;
          final bubbleColor = fromMe
              ? Colors.green.shade600
              : Colors.grey.shade200;
          final textColor =
          fromMe ? Colors.white : Colors.black87;

          // Determine if it’s a voice message
          final isVoice = msg.messageType == 'voice' ||
              msg.messageType == 'audio';

          final bubbleId = (msg.messageId?.toString() ??
              'temp-${msg.createdAt?.microsecondsSinceEpoch ?? msg.hashCode}');

          return Align(
            alignment: fromMe
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxWidth:
                MediaQuery.of(context).size.width * 0.78,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isVoice
                  ? VoiceBubble(
                path: msg.message ?? '',
                fromMe: fromMe,
                pm: widget.pmFeed,
                id: bubbleId,
                activeAudioId: messageController
                    .activeAudioIdString, // RxnString
                // your AudioPlayerManager instance
              )
                  : Column(
                crossAxisAlignment: align,
                children: [
                  Text(
                    msg.message ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });

  }
}