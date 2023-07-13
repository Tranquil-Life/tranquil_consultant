import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_boxes/shared/chat_box_base.dart';

import 'package:flutter/material.dart';


class RepliedChatBox extends StatelessWidget {
  RepliedChatBox({
    Key? key,
    required this.backgroundColor,
    this.message})
      : super(key: key);

  final Color backgroundColor;
  final Message? message;

  ChatController chatController = Get.put(ChatController());

  Widget _message() {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(fromYou: true),
          SizedBox(height: 3),
          Obx(()=>Text(ChatController.instance.quoteMsg.value,
            style: TextStyle(color: ColorPalette.black),
          ),)
        ],
      ),
    );

    // switch (message.type) {
    //   // case MessageType.image:
    //   // case MessageType.video:
    //   // case MessageType.audio:
    //   //   return _MediaReplyWidget(message: message);
    //   default:
    //     return const Padding(
    //       padding: EdgeInsets.all(3),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           _Header(fromYou: true),
    //           SizedBox(height: 3),
    //           Text("message.data"),
    //         ],
    //       ),
    //     );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Stack(
        children: [
          ChatBoxBase(
            padding: 4,
            heightScale: 0.9,
            color: backgroundColor,
            child: MyDefaultTextStyle(
              inherit: true,
              style: TextStyle(
                color:Colors.white,
              ),
              child: _message(),
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkResponse(
                containedInkWell: true,

                highlightShape: BoxShape.rectangle,
                onTap: () {
                  // final chatBloc = context.read<ChatBloc>();
                  // final replyIndex =
                  // chatBloc.chatMessagesNotifier.value.indexOf(message.repliedMessage);
                  // if (replyIndex < 0) return;
                  // log( chatBloc.chatMessagesNotifier.value.where((element) => element == message.repliedMessage).toList().first.message);
                  // chatBloc.add(ScrollToChatEvent(replyIndex));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _MediaReplyWidget extends StatefulWidget {
//   const _MediaReplyWidget({Key? key, required this.message}) : super(key: key);
//
//   final ReplyMessage message;
//
//   @override
//   State<_MediaReplyWidget> createState() => _MediaReplyWidgetState();
// }
//
// class _MediaReplyWidgetState extends State<_MediaReplyWidget> {
//   late final PlayerController player;
//   String duration = '';
//
//   // Color get color =>
//   //     widget.message.repliedMessage.fromYou ? Colors.white70 : Colors.black54;
//
//   @override
//   void initState() {
//     // if (widget.message.repliedMessage.type == MessageType.audio) {
//     //   _initAudio();
//     // }
//     super.initState();
//   }
//
//   Future _initAudio() async {
//     final String path;
//     player = PlayerController();
//     // if (widget.message.repliedMessage.isSent) {
//     //   final cachedFile = await DefaultCacheManager().getSingleFile(
//     //     widget.message.repliedMessage.data,
//     //   );
//     //   path = cachedFile.path;
//     // } else {
//     //   path = widget.message.repliedMessage.data;
//     // }
//     await player.preparePlayer(path);
//     if (!mounted) return;
//     setState(() => duration = TimeFormatter.toTimerString(player.maxDuration));
//   }
//
//   // Widget _labelWidgetBuilder() {
//   //   switch (widget.message.repliedMessage.type) {
//   //     case MessageType.video:
//   //       return _MediaWidget(text: 'Video', icon: Icons.image, color: color);
//   //     case MessageType.audio:
//   //       return Row(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           _MediaWidget(text: 'Audio', icon: Icons.mic, color: color),
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(horizontal: 8),
//   //             child: SizedBox.square(
//   //               dimension: 6,
//   //               child: Container(
//   //                 decoration: BoxDecoration(
//   //                   color: color,
//   //                   shape: BoxShape.circle,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //           Text(duration),
//   //         ],
//   //       );
//   //     default:
//   //       return _MediaWidget(text: 'Image', icon: Icons.image, color: color);
//   //   }
//   // }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return SizedBox(
//   //     height: 48,
//   //     child: Row(
//   //       crossAxisAlignment: CrossAxisAlignment.stretch,
//   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //       children: [
//   //         Align(
//   //           alignment: Alignment.centerLeft,
//   //           child: Padding(
//   //             padding: const EdgeInsets.only(left: 4),
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 _Header(fromYou: widget.message.fromYou),
//   //                 const SizedBox(height: 2),
//   //                 _labelWidgetBuilder(),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //         const SizedBox(width: 16),
//   //         if (widget.message.repliedMessage.type != MessageType.audio)
//   //           SizedBox(
//   //             width: 56,
//   //             child: Builder(builder: (_) {
//   //               if (widget.message.repliedMessage.type == MessageType.image) {
//   //                 return Image.network(
//   //                   widget.message.repliedMessage.data,
//   //                   fit: BoxFit.cover,
//   //                   errorBuilder: (_, __, ___) => Icon(
//   //                     Icons.broken_image_outlined,
//   //                     color: color,
//   //                     size: 40,
//   //                   ),
//   //                 );
//   //               }
//   //               return FutureBuilder<File?>(
//   //                 future: VideoLayout.getVideoThumb(
//   //                   widget.message.repliedMessage.data,
//   //                   !widget.message.isSent,
//   //                 ),
//   //                 builder: (_, AsyncSnapshot<File?> snaoshot) {
//   //                   if (snaoshot.data == null) {
//   //                     return const Icon(Icons.video_file, size: 40);
//   //                   }
//   //                   return Image.file(snaoshot.data!, fit: BoxFit.cover);
//   //                 },
//   //               );
//   //             }),
//   //           ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }

class _MediaWidget extends StatelessWidget {
  const _MediaWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 2),
        Text(text),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.fromYou}) : super(key: key);
  final bool fromYou;

  @override
  Widget build(BuildContext context) {
    return Text(
      fromYou ? 'You' : "consultant!.displayName",
      style: TextStyle(
        color: Color.lerp(
          Colors.white,
          ColorPalette.green[800],
          fromYou ? 0.5 : 1,
        )!,
      ),
    );
  }
}