part of '../screens/chat_screen.dart';

class InputBar extends StatefulWidget {
  final ChatController chatController;
  final RecordingController recordingController;
  final Future Function() startRecording;
  final Future Function() stopRecording;
  final bool showMic; // local UI state hint from parent
  final Future Function() uploadVn;
  final UploadController uploadController;
  final Timer? timer;
  final ClientUser? client;
  final int? chatId;

  const InputBar({
    super.key,
    required this.chatController,
    required this.recordingController,
    required this.startRecording,
    required this.stopRecording,
    required this.showMic,
    required this.uploadVn,
    required this.uploadController,
    this.timer,
    required this.client,
    this.chatId,
  });

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  late final TextEditingController textController;
  bool isMicVisible = false; // local: toggles mic vs send based on text input

  @override
  void initState() {
    super.initState();
    isMicVisible = widget.showMic;
    textController = TextEditingController();

    textController.addListener(() {
      final empty = textController.text.trim().isEmpty;
      // mic visible only when input is empty
      if (isMicVisible != empty) {
        setState(() => isMicVisible = empty);
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    // ensure bottom sheet / dialog states are correct before starting
    try {
      widget.uploadController.uploading.value = true;

      // If currently recording, upload the voice note
      if (widget.recordingController.isRecording.value) {
        // stop timer first to avoid double triggers
        widget.timer?.cancel();

        await widget.uploadVn();

        // reset timer counter (RxInt)
        widget.recordingController.recordingDuration.value = 0;
        // after VN upload, show mic again
        if (mounted) setState(() => isMicVisible = true);
      } else {
        // Send text message
        final id = widget.chatId;
        final cl = widget.client;
        if (id == null || cl?.id == null) {
          debugPrint('InputBar: chatId or client.id is null; aborting text upload.');
          return;
        }

        await widget.uploadController.handleTextUpload(
          chatId: id,
          message: textController.text,
          quotedMessage: widget.chatController.replyMessage.value,
          clientID: cl!.id!,
        );

        textController.clear(); // listener will flip mic visibility
      }
    } catch (e, st) {
      debugPrint('InputBar upload failed: $e\n$st');
    } finally {
      widget.uploadController.uploading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // derive current recording flag once per build for local logic;
    // reactive parts below are wrapped with Obx individually
    final rec = widget.recordingController.isRecording.value;

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
            // quote bar expands/collapses reactively
            Obx(() => Visibility(
              visible: widget.chatController.isExpanded.value,
              child: const QuoteInputBarExt(),
            )),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left icon: attach or trash (depends on recording)
                Obx(() {
                  final isRec = widget.recordingController.isRecording.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: AnimatedCrossFade(
                      duration: kTabScrollDuration,
                      crossFadeState: isRec
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: IconButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const AttachmentSheet(),
                        ),
                        icon: const Icon(
                          Icons.attach_file,
                          color: ColorPalette.green,
                          size: 28,
                        ),
                      ),
                      secondChild: IconButton(
                        onPressed: () async {
                          await widget.stopRecording();
                          widget.timer?.cancel();
                          widget.recordingController.recordingDuration.value = 0;
                          if (mounted) setState(() => isMicVisible = true);
                        },
                        icon: const Icon(
                          TranquilIcons.trash,
                          color: ColorPalette.green,
                          size: 27,
                        ),
                      ),
                    ),
                  );
                }),

                // Middle: either recording time or text field (reacts to isRecording)
                Expanded(
                  child: Obx(() {
                    final isRec = widget.recordingController.isRecording.value;
                    if (isRec) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 13),
                        child: Obx(() => Text(
                          widget.recordingController.time.value,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      );
                    }
                    return TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textController,
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

                // Right: mic / send button + loader
                Obx(() {
                  final isRec = widget.recordingController.isRecording.value;
                  final uploading = widget.uploadController.uploading.value;

                  return AnimatedContainer(
                    duration: kThemeChangeDuration,
                    padding: const EdgeInsets.all(6),
                    margin: EdgeInsets.only(
                      right: isRec ? 6 : 8,
                      bottom: 5,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.green,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // show mic only if no text and not recording
                        if (isMicVisible && !isRec) {
                          showDialog(
                            context: context,
                            builder: (_) => VoiceNoteDialog(
                              onPressed: () async {
                                await widget.startRecording();
                                if (mounted) setState(() {}); // minimal local refresh
                              },
                            ),
                          );
                        } else {
                          _handleUpload();
                        }
                      },
                      child: AnimatedCrossFade(
                        duration: kThemeChangeDuration,
                        crossFadeState: (isMicVisible && !isRec)
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Padding(
                          padding: isRec
                              ? const EdgeInsets.fromLTRB(3, 1, 2, 1)
                              : const EdgeInsets.fromLTRB(4, 3, 2, 3),
                          child: uploading
                              ? CustomLoader.widget(ColorPalette.white)
                              : const Icon(Icons.send, color: Colors.white, size: 22),
                        ),
                        secondChild: const Icon(Icons.mic, color: Colors.white, size: 28),
                      ),
                    ),
                  );
                }),
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
    final controller = ChatController.instance;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          const RepliedChatBox(backgroundColor: Color(0xffE1DFDF)),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                controller.isExpanded.value = false;
                controller.replyMessage.value = Message();
              },
              child: const Icon(Icons.close_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
