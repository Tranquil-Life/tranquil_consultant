import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/tranquil_icons.dart';
import 'package:tl_consultant/app/presentation/widgets/app_bar_button.dart';
import 'package:tl_consultant/app/presentation/widgets/swipeable.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/services/formatters.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/attachment_sheet.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/chat_item.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/replied_chat_box.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

part '../widgets/chat_app_bar.dart';

part '../widgets/input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.put(ChatController());

  @override
  void initState() {
    chatController.getChatMessages();
    super.initState();
  }

  // getMesages(){
  //   var seen = Set<Message>();
  //   List<String> data = [];
  //   chatController.messages.where((message) => seen.add(message)).toList().forEach((element) {
  //     data.add(element.message!);
  //   });
  //   print(data);
  //
  // }

  @override
  Widget build(BuildContext context) {
    setStatusBarBrightness(false);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/chat_bg.png'),
            fit: BoxFit.cover,
            color: Colors.black26,
            colorBlendMode: BlendMode.darken,
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  _TitleBar(),
                  GetBuilder<ChatController>(
                    global: false,
                    init: chatController,
                    builder: (controller) =>
                        _Messages(messages: chatController.messages),
                  ),
                  const SafeArea(top: false, child: _InputBar()),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class _Messages extends StatefulWidget {
  final List<Message>? messages;

  const _Messages({this.messages});

  @override
  State<_Messages> createState() => _MessagesState();
}

class _MessagesState extends State<_Messages>
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
          child: ScrollablePositionedList.builder(
            reverse: true,
            itemCount: widget.messages!.length,
            physics: const BouncingScrollPhysics(),
            itemScrollController:
            chatController.scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            itemBuilder: (_, index){
              return ChatItem(
                widget.messages![index],
                highlightAnim: highlightAnim,
                animate: index == -1,
              );
            },
          )
      ),
    );
  }
}