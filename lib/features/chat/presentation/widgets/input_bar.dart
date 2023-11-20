part of '../screens/chat_screen.dart';

class _InputBar extends StatefulWidget {
  const _InputBar({Key? key, required this.chatWidget}) : super(key: key);

  final Widget chatWidget;

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  ChatController chatController = Get.put(ChatController());

  @override
  void initState(){

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Container(
        padding: const EdgeInsets.only(bottom: 1),
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Obx(()=>Visibility(
              visible: chatController.isExpanded.value,
              child: QuoteInputBarExt(),
            ),),

            SizedBox(
                child: widget.chatWidget
            )

          ],
        ),
      ),
    );
  }
}

class QuoteInputBarExt extends StatelessWidget {
  ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            RepliedChatBox(
              backgroundColor: const Color(0xffE1DFDF),
              // backgroundColor: Color.lerp(
              //   Colors.black,
              //   ColorPalette.green,
              //   0.82,
              // )!,
            ),

            Positioned(
                right: 5,
                top: 5,
                child: GestureDetector(
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                  ),
                  onTap: () {
                    controller.isExpanded.value = false;
                    controller.replyMessage.value = Message();
                  },
                ))

          ],
        )
    );
  }
}
