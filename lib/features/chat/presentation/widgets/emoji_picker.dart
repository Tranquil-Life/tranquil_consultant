import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class CustomEmojiPicker extends StatefulWidget {
  const CustomEmojiPicker({Key? key, this.onEmojiSelected}) : super(key: key);
  final void Function(Category?, Emoji)? onEmojiSelected;

  @override
  State<CustomEmojiPicker> createState() => _CustomEmojiPickerState();
}

class _CustomEmojiPickerState extends State<CustomEmojiPicker> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // EmojiPicker(
    //   onEmojiSelected: widget.onEmojiSelected,
    //   onBackspacePressed: () {
    //     // Do something when the user taps the backspace button (optional)
    //   },
    //   // textEditingController: textEditionController,
    //   // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
    //   config: Config(
    //     columns: 7,
    //     emojiSizeMax: 32 *
    //         (foundation.defaultTargetPlatform == TargetPlatform.iOS
    //             ? 1.30
    //             : 1.0),
    //     // Issue: https://github.com/flutter/flutter/issues/28894
    //     verticalSpacing: 0,
    //     horizontalSpacing: 0,
    //     gridPadding: EdgeInsets.zero,
    //     initCategory: Category.RECENT,
    //     bgColor: Colors.transparent,
    //     indicatorColor: Theme.of(context).primaryColor,
    //     iconColor: Theme.of(context).primaryColor,
    //     iconColorSelected: Theme.of(context).primaryColor,
    //     backspaceColor: Theme.of(context).primaryColor,
    //     skinToneDialogBgColor: Colors.white,
    //     skinToneIndicatorColor: Colors.grey,
    //     enableSkinTones: true,
    //     recentsLimit: 28,
    //     noRecents: const Text(
    //       'No Recents',
    //       style: TextStyle(fontSize: 20, color: Colors.black26),
    //       textAlign: TextAlign.center,
    //     ),
    //     // Needs to be const Widget
    //     loadingIndicator: const SizedBox.shrink(),
    //     // Needs to be const Widget
    //     tabIndicatorAnimDuration: kTabScrollDuration,
    //     categoryIcons: const CategoryIcons(),
    //     buttonMode: ButtonMode.MATERIAL,
    //   ),
    // );
  }
}
