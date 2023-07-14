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
                  Expanded(child: _Messages(chatController: chatController)),
                  SafeArea(top: false, child: _InputBar()),
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
  const _Messages({Key? key, required this.chatController}) : super(key: key);
  final ChatController chatController;

  @override
  State<_Messages> createState() => _MessagesState();
}

class _MessagesState extends State<_Messages>
    with SingleTickerProviderStateMixin {
  ChatController chatController = Get.put(ChatController());

  late final AnimationController animController;
  late final Animation<double> highlightAnim;

  Timer? callTimer;

  getMessages() async{
    Timer.periodic(const Duration(seconds: 3), (timer) {
      callTimer = timer;
      chatController.getMessages();
    });
  }

  @override
  void initState() {
    getMessages();
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
  void didChangeDependencies() {
    // Timer.periodic(Duration(minutes: 20), (timer) {
    //   getMessages();
    // });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    try{
      callTimer?.cancel();
      chatController.chatsStreamController.close();

      animController.dispose();
    }catch(e){
      log("DISPOSE: Error: $e");
    }
    super.dispose();
  }

  Future handleRefresh() async {
    getMessages();
  }


  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
        child: StreamBuilder<List<Message>>(
          stream: chatController.chatStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print("SNAPSOT: ${snapshot.data}");
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            else{
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(color: ColorPalette.green,),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if(!snapshot.hasData || (snapshot.data is List && (snapshot.data as List).isEmpty)){
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'No messages here yet.\nTalk to your client!',
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text('👋', style: TextStyle(fontSize: 64)),
                          ],
                        ),
                      ),
                    );
                  }
                  else{
                    List<Message> messages = snapshot.data;
                    return ScrollablePositionedList.builder(
                      reverse: true,
                      itemCount: snapshot.data.length,
                      physics: const BouncingScrollPhysics(),
                      itemScrollController:
                      widget.chatController.scrollController,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom,
                      ),
                      itemBuilder: (_, index) => ChatItem(
                        //key: ValueKey(messages[index].id ?? 'sending-$index'),
                        snapshot.data[index],
                        highlightAnim: highlightAnim,
                        animate: index == -1,
                      ),
                    );
                  }
                case ConnectionState.none:
                default:
                  return const Center(
                    child: CircularProgressIndicator(color: ColorPalette.green),
                  );
              }
            }
          },
        )
    );
  }
}