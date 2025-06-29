import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/receiver/text.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/receiver/voice_note.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/image.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/text.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/video.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/voice_note.dart';

class ChatItem extends StatefulWidget {
  const ChatItem(
    this.message, {
    super.key,
    required this.animate,
    required this.highlightAnim,
    this.onReactionTap,
    this.onRelease,
    this.isExpanded = false,
    this.isSender = false,
    this.onEmojiSelected,
  });

  final Message message;
  final bool animate;
  final Animation<double> highlightAnim;
  final VoidCallback? onReactionTap;
  final VoidCallback? onRelease;

  final bool isExpanded;
  final bool? isSender;
  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  State<ChatItem> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  ChatController chatController = Get.put(ChatController());

  bool dialogShowing = false;

  final itemWidgetKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animate
          ? widget.highlightAnim
          : const AlwaysStoppedAnimation(0),
      builder: (context, _) => SwipeTo(
        onLeftSwipe: (DragUpdateDetails details) {
          // chatController.isExpanded.value = true;

          // print(Timestamp.fromDate(widget.message.createdAt!));
          // Map<String, dynamic> map = {
          //   "id": widget.message.messageId,
          //   "from":widget.message.userId,
          //   'meeting_id':widget.message.meetingId,
          //   "user_type": widget.message.userType,
          //   "display_name": widget.message.username,
          //   'message': widget.message.message,
          //   'message_type':widget.message.messageType,
          //   'caption':widget.message.caption,
          //   'reply_message':widget.message.replyMessage == null ? null : widget.message.replyMessage!.toJson(),
          //   "created_at": widget.message.createdAt!,
          // };

          //chatController.replyMessage.value =  MessageModel.fromJson(map);
        },
        iconColor: ColorPalette.white,
        child: Container(
          key: itemWidgetKey,
          color: ColorPalette.green.withOpacity(
            widget.animate ? widget.highlightAnim.value * 0.4 : 0.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: () {
              if (widget.message.fromYou) {
                switch (widget.message.type) {
                  case MessageType.image:
                    return SenderChatImage(widget.message);
                  case MessageType.video:
                    return SenderChatVideo(widget.message);
                  case MessageType.audio:
                    return SenderChatVoiceNote(widget.message);
                  default:
                    return SenderChatText(widget.message);
                }
              } else {
                switch (widget.message.type) {
                  // case MessageType.image:
                  // return ReceiverChatImage(widget.message);
                  // case MessageType.video:
                  // return ReceiverChatVideo(widget.message);
                  case MessageType.audio:
                    return ReceiverChatVoiceNote(widget.message);
                  default:
                    return ReceiverChatText(widget.message);
                }
              }
            }(),
          ),
        ),
      ),
    );
  }
}
