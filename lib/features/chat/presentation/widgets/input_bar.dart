part of '../screens/chat_screen.dart';

class _InputBar extends StatelessWidget {
  final ChatController chatController;
  final RecordingController recordingController;
  final Future Function() startRecording;
  final Future Function() stopRecording;
  final bool showMic;

  const _InputBar({
    required this.chatController,
    required this.recordingController,
    required this.startRecording,
    required this.stopRecording,
    required this.showMic
  });



  // bool sendBtnClicked = false;

  _handleUpload() async {
    if(recordingController.isRecording.value){
      chatController.audioFile = await stopRecording();

      await UploadController().handleVoiceNoteUpload(
          file: chatController.audioFile,
          quotedMessage: chatController.replyMessage.value);    
      
    }else{
      await UploadController().handleTextUpload(
          quotedMessage: chatController.replyMessage.value);
    }

    // if (!AppData.hasShownChatDisableDialog) {
    //   upload = await showDialog(
    //     context: context,
    //     builder: (_) => const DisableAccountDialog(),
    //   ) ??
    //       false;
    // }

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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //display using an animation delete icon while recording
                    Visibility(
                      visible: recordingController.isRecording.value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: AnimatedCrossFade(
                          duration: kTabScrollDuration,
                          crossFadeState: recordingController.isRecording.value
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
                            onPressed:(){
                              stopRecording();
                            },
                            icon: const Icon(
                              TranquilIcons.trash,
                              color: ColorPalette.green,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Typing text
                    Expanded(
                      child: Builder(builder: (context) {
                        if (recordingController.isRecording.value) {
                          return Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 13),
                              child: Obx(()=>Text(
                                recordingController.time.value,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              )));
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

                    // GestureDetector(
                    //   // maxOffset: 32,
                    //   // enabled: showMic,
                    //   // canLongPress: true,
                    //   // resetOnRelease: true,
                    //   // swipedWidget: const Icon(Icons.mic, color: ColorPalette.red),
                    //   // onStateChanged: (isActive) {
                      //   isActive = true;
                      //   if (showMic && isActive){
                      //     //print("RECORDER STARTED");
                      //     startRecording();
                      //   }
                    //   // },
                    //   child:
                    // ),

                    AnimatedContainer(
                      duration: kThemeChangeDuration,
                      padding: const EdgeInsets.all(6),
                      margin:
                      EdgeInsets.only(
                          right: recordingController.isRecording.value ? 6 : 8,
                          bottom: 5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorPalette.green,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          if(showMic){
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    VoiceNoteDialog(onPressed: ()=>startRecording()));
                          }else{
                            _handleUpload();
                          }
                        },
                        child: AnimatedCrossFade(
                          duration: kThemeChangeDuration,
                          crossFadeState: showMic
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: Padding(
                            padding: recordingController.isRecording.value
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

                  ],
                )
            )

          ],
        ),
      ),
    );
  }
}





class QuoteInputBarExt extends StatelessWidget {
  ChatController controller = Get.put(ChatController());

  QuoteInputBarExt({super.key});

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
