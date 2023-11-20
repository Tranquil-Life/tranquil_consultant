import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/moods.dart';
import 'package:tl_consultant/core/utils/reaction_path.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/emoji_picker.dart';

class ReactionDialog extends StatefulWidget {
  const ReactionDialog({Key? key,
    required this.child,
    this.onEmojiSelected,
    this.isSender = false,
  })
      : super(key: key);
  final Widget child;
  final bool? isSender;
  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  State<ReactionDialog> createState() => _ReactionDialogState();
}

class _ReactionDialogState extends State<ReactionDialog> {
  bool dialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 82
                          ),
                          child: CustomPaint(
                            painter: ReactionPath(isSender: widget.isSender!),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                      (index) =>
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 10, top: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.onEmojiSelected!(
                                                null, Emoji(reactions[index], ''));
                                          },
                                          child: Text(
                                            widget.isSender!
                                                ?
                                            '${reactions[index]}  '
                                                : ' ${reactions[index]}',
                                            style: const TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                )
                                  ..add(Padding(
                                    padding: widget.isSender! ? const EdgeInsets.only(
                                        right: 10, bottom: 10): const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: IconButton(
                                      icon: Icon(dialogShowing
                                          ? Icons.close
                                          : Icons.more_horiz),
                                      onPressed: () {
                                        setState(() {
                                          dialogShowing = !dialogShowing;
                                        });
                                      },
                                    ),
                                  )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),

                const SizedBox(
                  height: 16,
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(
                    height: 50,
                  ),
                  secondChild: SizedBox(
                      height: 300,
                      child: CustomEmojiPicker(
                        onEmojiSelected: widget.onEmojiSelected,
                      )),
                  crossFadeState: dialogShowing
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 100),
                ),
              ],
            )
          ],
        )
    );
  }
}