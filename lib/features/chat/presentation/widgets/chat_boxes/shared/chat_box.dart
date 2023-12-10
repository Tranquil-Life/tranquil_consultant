import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    Key? key,
    required this.child,
    required this.time,
    required this.color,
    required this.axisAlignment,
    this.padding = 5,
    this.reaction,
    this.onReactionTap,
    this.swipeRight = true,
    this.onRelease,
    this.heightScale = 1,
    this.isExpanded = false,
  }) : super(key: key);

  final String time;
  final String? reaction;
  final Color color;
  final Widget child;
  final CrossAxisAlignment axisAlignment;
  final VoidCallback? onReactionTap;
  final VoidCallback? onRelease;
  final bool swipeRight;
  final double heightScale;
  final double padding;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: axisAlignment,
        children: [
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onLongPress: (){
                    //..
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isExpanded ? double.infinity : 200),
                    child: Container(
                      width: isExpanded? displayWidth(context):null,
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.all(12),
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
                    ),
                  )
                ),
                // Visibility(
                //   visible: reaction != null,
                //   child: Positioned(
                //       bottom: -8,
                //       right: -8,
                //       child: GestureDetector(
                //         onTap: onReactionTap,
                //         child: Container(
                //             padding: const EdgeInsets.all(5),
                //             decoration: BoxDecoration(
                //               color: color,
                //               borderRadius: BorderRadius.circular(7),
                //             ),
                //             child: Text(
                //               reaction ?? '',
                //               style: const TextStyle(fontSize: 18),
                //             )),
                //       )),
                // )
              ],
            ),
          ),
          SizedBox(height:reaction != null? 10:4),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}