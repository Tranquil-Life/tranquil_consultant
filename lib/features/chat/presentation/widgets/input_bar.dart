// part of '../screens/chat_screen.dart';
//
// class InputBar extends StatefulWidget {
//   final ChatController chatController;
//   final RecordingController recordingController;
//   final UploadController uploadController;
//   final Future Function() startRecording;
//   final Future Function() stopRecording;
//   final Future Function() uploadVn;
//   final bool showMic;
//   final Timer? timer;
//   final ClientUser client;
//   final int? chatId;
//
//   const InputBar({super.key, required this.chatController,
//     required this.recordingController,
//     required this.startRecording,
//     required this.stopRecording,
//     required this.showMic, required this.uploadVn,
//     this.timer, required this.uploadController, required this.client, this.chatId});
//
//   @override
//   State<InputBar> createState() => _InputBarState();
// }
//
// class _InputBarState extends State<InputBar> {
//   TextEditingController textController = TextEditingController();
//   UploadController uploadController = Get.put(UploadController());
//
//   bool isMicVisible = false;
//
//   _handleUpload() async {
//     widget.uploadController.uploading.value = true;
//     if (widget.recordingController.isRecording.value) {
//       widget.uploadVn();
//       widget.timer?.cancel();
//       setState(() {});
//       widget.recordingController.recordingDuration.value = 0;
//       widget.uploadController.uploading.value = false;
//
//
//       // widget.chatController.audioFile = await widget.stopRecording();
//       //
//       // debugPrint(
//       //     "INPUT BAR: upload recording: ${widget.chatController.audioFile}");
//       //
//       // await UploadController().handleVoiceNoteUpload(
//       //     file: widget.chatController.audioFile,
//       //     quotedMessage: widget.chatController.replyMessage.value);
//     } else {
//
//       ///Send text message
//       await UploadController().handleTextUpload(
//           chatId: widget.chatId!,
//           message:
//           textController.text,
//           quotedMessage: widget.chatController.replyMessage.value,
//           clientID
//               : widget.client.id!);
//
//       widget.uploadController.uploading.value = false;
//
//       textController.clear();
//     }
//
//     // if (!AppData.hasShownChatDisableDialog) {
//     //   upload = await showDialog(
//     //     context: context,
//     //     builder: (_) => const DisableAccountDialog(),
//     //   ) ??
//     //       false;
//     // }
//   }
//
//   @override
//   void initState() {
//     isMicVisible = widget.showMic;
//
//     //re-instantiate the controller here to allow reuse after disposal
//     textController = TextEditingController();
//
//     textController.addListener(() {
//       setState(
//               () {
//             if (textController.text.removeAllWhitespace.isEmpty) {
//               isMicVisible = true;
//             } else {
//               isMicVisible = false;
//             }
//           });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(minHeight: 56),
//       child: Container(
//         padding: const EdgeInsets.only(bottom: 1),
//         margin: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             Obx(
//                   () =>
//                   Visibility(
//                     visible: widget.chatController.isExpanded.value,
//                     child: QuoteInputBarExt(),
//                   ),
//             ),
//             SizedBox(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     //display using an animation delete icon while recording
//                     Visibility(
//                       visible: widget.recordingController.isRecording.value,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 7),
//                         child: AnimatedCrossFade(
//                           duration: kTabScrollDuration,
//                           crossFadeState:
//                           widget.recordingController.isRecording.value
//                               ? CrossFadeState.showSecond
//                               : CrossFadeState.showFirst,
//                           firstChild: IconButton(
//                             onPressed: () =>
//                                 showModalBottomSheet(
//                                   context: context,
//                                   backgroundColor: Colors.transparent,
//                                   builder: (_) => const AttachmentSheet(),
//                                 ),
//                             icon: const Icon(
//                               Icons.attach_file,
//                               color: ColorPalette.green,
//                               size: 28,
//                             ),
//                           ),
//                           secondChild: IconButton(
//                             onPressed: () {
//                               widget.stopRecording();
//                               widget.timer?.cancel();
//                               setState(() {});
//                               widget.recordingController.recordingDuration.value = 0;
//                               isMicVisible = true;
//                             },
//                             icon: const Icon(
//                               TranquilIcons.trash,
//                               color: ColorPalette.green,
//                               size: 27,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     //Typing text
//                     Expanded(
//                       child: Builder(builder: (context) {
//                         if (widget.recordingController.isRecording.value) {
//                           return Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 4, bottom: 13),
//                               child: Obx(() =>
//                                   Text(
//                                     widget.recordingController.time.value,
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   )));
//                         }
//                         return TextField(
//                           minLines: 1,
//                           maxLines: 5,
//                           controller: textController,
//                           textInputAction: TextInputAction.newline,
//                           textCapitalization: TextCapitalization.sentences,
//                           decoration: const InputDecoration(
//                             filled: false,
//                             hintText: 'Type something...',
//                             border: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             hintStyle: TextStyle(fontWeight: FontWeight.w600),
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: 16,
//                               horizontal: 4,
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//
//                     AnimatedContainer(
//                       duration: kThemeChangeDuration,
//                       padding: const EdgeInsets.all(6),
//                       margin: EdgeInsets.only(
//                           right:
//                           widget.recordingController.isRecording.value ? 6 : 8,
//                           bottom: 5),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: ColorPalette.green,
//                       ),
//                       child: Obx(() =>
//                           GestureDetector(
//                             onTap: () {
//                               if (isMicVisible &&
//                                   !widget.recordingController.isRecording
//                                       .value) {
//                                 showDialog(
//                                     context: context,
//                                     builder: (_) =>
//                                         VoiceNoteDialog(onPressed: () {
//                                           widget.startRecording();
//                                           setState(() {});
//                                         }));
//                               } else {
//                                 _handleUpload();
//                               }
//                             },
//                             child: AnimatedCrossFade(
//                               duration: kThemeChangeDuration,
//                               crossFadeState: isMicVisible &&
//                                   !widget.recordingController.isRecording.value
//                                   ? CrossFadeState.showSecond
//                                   : CrossFadeState.showFirst,
//                               firstChild: Padding(
//                                 padding: widget.recordingController.isRecording
//                                     .value
//                                     ? const EdgeInsets.fromLTRB(3, 1, 2, 1)
//                                     : const EdgeInsets.fromLTRB(4, 3, 2, 3),
//                                 child: widget.uploadController.uploading.value
//                                     ? CustomLoader.widget(ColorPalette.white)
//                                     : Icon(
//                                   Icons.send,
//                                   color: Colors.white,
//                                   size: 22,
//                                 ),
//                               ),
//                               secondChild: const Icon(
//                                 Icons.mic,
//                                 color: Colors.white,
//                                 size: 28,
//                               ),
//                             ),
//                           )),
//                     ),
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class QuoteInputBarExt extends StatelessWidget {
//   ChatController controller = Get.put(ChatController());
//
//   QuoteInputBarExt({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Stack(
//           children: [
//             RepliedChatBox(
//               backgroundColor: const Color(0xffE1DFDF),
//               // backgroundColor: Color.lerp(
//               //   Colors.black,
//               //   ColorPalette.green,
//               //   0.82,
//               // )!,
//             ),
//             Positioned(
//                 right: 5,
//                 top: 5,
//                 child: GestureDetector(
//                   child: const Icon(
//                     Icons.close_rounded,
//                     size: 20,
//                   ),
//                   onTap: () {
//                     controller.isExpanded.value = false;
//                     controller.replyMessage.value = Message();
//                   },
//                 ))
//           ],
//         ));
//   }
// }