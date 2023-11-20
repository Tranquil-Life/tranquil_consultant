// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:tl_consultant/app/presentation/widgets/custom_loader.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';

import 'package:flutter/material.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/screens/image_full_view.dart';

class ChatImageLayout extends StatelessWidget {
  ChatImageLayout({Key? key, required this.message}) : super(key: key);

  final Message message;

  bool canOpenFullview = true;

  static final _errorWidget = Container(
    color: Colors.grey[300],
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.grey[700], size: 80),
          Text(
            'Image unavailable',
            style: TextStyle(color: Colors.grey[800]!, fontSize: 18),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final heroTag = '${message.messageId}-${message.data}';
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.6,
      child: GestureDetector(
        onTap: () {
          // if (!canOpenFullview) return;
          // Navigator.of(context).pushNamed(
          //   ImageFullView.routeName,
          //   arguments: ImageFullViewData(
          //     heroTag: heroTag,
          //     image: (message.isSent
          //         ? NetworkImage(message.data)
          //         : FileImage(File(message.data))) as ImageProvider<Object>,
          //   ),
          // );
        },
        child: Hero(
          tag: heroTag,
          child: Builder(
            builder: (_) {
              Widget frameBuilder(_, Widget child, int? frame, __) {
                if (frame == null) {
                  return CustomLoader.widget(
                    message.fromYou ? Colors.white : null,
                  );
                }
                canOpenFullview = true;
                return child;
              }

              return SizedBox();

              Widget errorBuilder(_, __, ___) {
                canOpenFullview = false;
                return _errorWidget;
              }

              // if (message.isSent) {
              //   return Image.network(
              //     message.data,
              //     fit: BoxFit.cover,
              //     frameBuilder: frameBuilder,
              //     errorBuilder: errorBuilder,
              //   );
              // }
              // return Image.file(
              //   File(message.data),
              //   fit: BoxFit.cover,
              //   frameBuilder: frameBuilder,
              //   errorBuilder: errorBuilder,
              // );
            },
          ),
        ),
      ),
    );
  }
}