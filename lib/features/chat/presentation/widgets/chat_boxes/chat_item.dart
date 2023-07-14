import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/image.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/video.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/sender/voice_note.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/text_layout.dart';

class ChatItem extends StatefulWidget {
  const ChatItem(
      this.message,
      {
        Key? key,
        required this.animate,
        required this.highlightAnim,
        this.onReactionTap,
        this.onRelease,
        this.isExpanded = false,
        this.isSender=false,
        this.onEmojiSelected,
      }) : super(key: key);

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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animate ? widget.highlightAnim : const AlwaysStoppedAnimation(0),
      builder: (context, _) =>
          SwipeTo(
            onLeftSwipe: () {
              chatController.quoteMsg.value = widget.message.message!;
              chatController.parentId.value = widget.message.id!;
              chatController.isExpanded.value = true;
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
                        return ChatBox(
                          time: widget.message.timeSent ?? 'Sending',
                          color: ColorPalette.green,
                          axisAlignment: CrossAxisAlignment.end,
                          child: GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Visibility(
                                  visible: widget.message.parentMessage.isNotEmpty,
                                  child:  Container(
                                      width: 244,
                                      margin: EdgeInsets.only(bottom: 8),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: ColorPalette.green[800],
                                          borderRadius: BorderRadius.circular(8.0)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.message.fromYou
                                              ? "You" : "",
                                            style: TextStyle(color: ColorPalette.green[200]),),

                                          Text(
                                            widget.message.parentMessage,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                                // ClipRRect(
                                //   child: Container(
                                //     width: 244,
                                //     color: Colors.red,
                                //   ),
                                // ),

                                TextLayout(message: widget.message),
                              ],
                            ),
                          ),
                        );
                    }
                  }
                  else{
                    //TODO: Receiver widget
                  }
                }(),
              ),
            ),
          ),
    );
  }
}