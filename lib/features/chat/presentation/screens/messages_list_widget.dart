import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/chat_item.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages>
    with SingleTickerProviderStateMixin {
  ChatController chatController = Get.put(ChatController());

  late final AnimationController animController;
  late final Animation<double> highlightAnim;

  final ScrollController _scrollController = ScrollController();


  // Add a scroll listener to the list view
  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // User has reached the top of the list, load older messages
        chatController.loadOlderMessages();
      }
    });
  }

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

    _addScrollListener(); //initialize the scroll listener

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
    chatController.messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return Obx(()=>ListView.builder(
      physics: const BouncingScrollPhysics(),
      reverse: true,
      controller: _scrollController,
      itemCount: chatController.messages.length + (chatController.isLoadMoreRunning.value ? 1 : 0),
      itemBuilder: (context, index) {
        // Display messages in reverse order
        //final reversedIndex = chatController.messages.length - index - 1;

        if (index == chatController.messages.length) {
          // Display a loading indicator at the end of the list while loading more messages
          return const Center(
            child: CircularProgressIndicator(color: ColorPalette.green),
          );
        }

        return ChatItem(
          chatController.messages[index],
          highlightAnim: highlightAnim,
          animate: index == -1,
        );
      },
    ));
  }
}