part of '../screens/chat_screen.dart';

class _InputBar extends StatefulWidget {
  const _InputBar({Key? key}) : super(key: key);

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  ChatController chatController = Get.put(ChatController());

  bool sendBtnClicked = false;
  _handleUpload() async {
    sendBtnClicked = true;

    await chatController.handleTextUpload();
    await Future.delayed(Duration(seconds: 3));
    sendBtnClicked = false;

    setState(() {});

    // if (chatController.showMic) return;
    // File? file;
    // bool upload = true;
    // if (chatController.isRecording) file = await chatController.recorder.stop();
    // if (!AppData.hasShownChatDisableDialog) {
    //   upload = await showDialog(
    //     context: context,
    //     builder: (_) => const DisableAccountDialog(),
    //   ) ??
    //       false;
    // }
    // if (chatController.isRecording) {
    //   //handleRecordingUpload(file, upload);
    // } else {
    //   chatController.handleTextUpload(upload);
    // }
  }

  @override
  void initState() {
    chatController.recorder.init();
    chatController.textController.addListener(() {
      setState(() => chatController.micMode = chatController.textController.text.trim().isEmpty);
    });
    chatController.isRecordingStreamSub = chatController.recorder.omRecordingState.listen((event) {
      setState(() => chatController.isRecording = event);
    });
    super.initState();
  }

  @override
  void dispose() {
    chatController.isRecordingStreamSub?.cancel();
    chatController.textController.dispose();
    chatController.recorder.dispose();
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
            Obx(()=>
                Visibility(
                  visible: chatController.isExpanded.value,
                  child: QuoteInputBarExt(),
                ),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: AnimatedCrossFade(
                    duration: kTabScrollDuration,
                    crossFadeState: chatController.isRecording
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const AttachmentSheet(),
                      ),
                      icon: Icon(
                        Icons.attach_file,
                        color: ColorPalette.green,
                        size: 28,
                      ),
                    ),
                    secondChild: IconButton(
                      onPressed: chatController.recorder.stop,
                      icon: Icon(
                        TranquilIcons.trash,
                        color: ColorPalette.green,
                        size: 27,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    if (chatController.isRecording) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 13),
                        child: StreamBuilder<String>(
                          initialData: '00:00',
                          stream: chatController.recorder.onDurationText,
                          builder: (context, snapshot) => Text(
                            snapshot.data!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }
                    return TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: chatController.textController,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        filled: false,
                        hintText: 'Type something...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintStyle: TextStyle(fontWeight: FontWeight.w600),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                      ),
                    );
                  }),
                ),
                SwipeableWidget(
                  maxOffset: 32,
                  enabled: chatController.showMic,
                  canLongPress: true,
                  resetOnRelease: true,
                  swipedWidget: const Icon(Icons.mic, color: ColorPalette.red),
                  onStateChanged: (isActive) {
                    if (chatController.showMic && isActive) chatController.recorder.start();
                  },
                  child: AnimatedContainer(
                    duration: kThemeChangeDuration,
                    padding: const EdgeInsets.all(6),
                    margin:
                    EdgeInsets.only(right: chatController.isRecording ? 6 : 8, bottom: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.green,
                      border: chatController.isRecording
                          ? Border.all(color: ColorPalette.blue, width: 2)
                          : null,
                    ),
                    child: GestureDetector(
                      onTap: sendBtnClicked ? null : _handleUpload,
                      child: AnimatedCrossFade(
                        duration: kThemeChangeDuration,
                        crossFadeState: chatController.showMic
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Padding(
                          padding: chatController.isRecording
                              ? const EdgeInsets.fromLTRB(3, 1, 2, 1)
                              : const EdgeInsets.fromLTRB(4, 3, 2, 3),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        secondChild: const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteInputBarExt extends StatelessWidget {
  const QuoteInputBarExt({super.key});


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
                    ChatController.instance.isExpanded.value = false;
                    ChatController.instance.parentId.value = 0;
                  },
                ))

          ],
        )
    );
  }
}
