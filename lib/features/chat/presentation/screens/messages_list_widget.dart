import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/chat_item.dart';

class Messages extends StatefulWidget {
  final List<Message>? messages;

  const Messages({this.messages});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages>
    with SingleTickerProviderStateMixin {
  ChatController chatController = Get.put(ChatController());

  late final AnimationController animController;
  late final Animation<double> highlightAnim;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..animateTo(1, duration: Duration.zero);
    highlightAnim = animController.drive(TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.2),
    ]));
    super.initState();
  }


  @override
  void dispose() {
    try{
      animController.dispose();
    }catch(e){
      log("DISPOSE: Error: $e");
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: UnFocusWidget(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: false,
          itemCount: widget.messages!.length,
          itemBuilder: (context, index) {
            final message = widget.messages![index];

            return ChatItem(
              message,
              highlightAnim: highlightAnim,
              animate: index == -1,
            );
          },
        ),
        // child: ScrollablePositionedList.builder(
        //   reverse: true,
        //   itemCount: widget.messages!.length,
        //   physics: const BouncingScrollPhysics(),
        //   itemScrollController:
        //   fbChatController.scrollController,
        //   padding: EdgeInsets.only(
        //     bottom: MediaQuery.of(context).viewPadding.bottom,
        //   ),
        //   itemBuilder: (_, index){
        //     return ChatItem(
        //       widget.messages![index],
        //       highlightAnim: highlightAnim,
        //       animate: index == -1,
        //     );
        //   },
        // )
      ),
    );
  }
}