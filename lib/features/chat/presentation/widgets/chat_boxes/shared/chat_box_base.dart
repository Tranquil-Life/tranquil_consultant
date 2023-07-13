import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class ChatBoxBase extends StatelessWidget {
  const ChatBoxBase({
    Key? key,
    required this.child,
    required this.color,
    this.heightScale = 1,
    this.padding = 12,
  }) : super(key: key);

  final double heightScale;
  final double padding;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displayWidth(context),
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10 * heightScale),
      ),
      child: MyDefaultTextStyle(
        style: TextStyle(
          height: 1.3 * heightScale,
          fontSize: 16 * heightScale,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10 * heightScale),
          child: child,
        ),
      ),
    );
  }
}