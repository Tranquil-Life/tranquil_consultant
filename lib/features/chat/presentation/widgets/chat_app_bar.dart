import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/app_bar_button.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/services/formatters.dart';
import 'package:tl_consultant/features/chat/data/models/message_model.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

import 'package:tl_consultant/core/constants/constants.dart'
    show myId, consultant;

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  final duration = const Duration(minutes: 30);

  final videoCallController = VideoCallController.instance;
  final meetingsController = MeetingsController.instance;
  final chatController = ChatController.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: [
          const SizedBox(width: 18),
          isSmallScreen(context) ? const BackButtonWhite() : SizedBox.shrink(),
          isSmallScreen(context)
              ? const SizedBox(width: 16)
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: UserAvatar(
              size: isSmallScreen(context) ? 44 : 70,
              imageUrl:
                  meetingsController.currentMeeting.value?.client.avatarUrl,
              source: AvatarSource.url,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meetingsController.currentMeeting.value!.client.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen(context) ? AppFonts.largeSize : 22,
                  ),
                ),
                Text(
                  TimeFormatter.toReadableString(duration.inMilliseconds),
                  style: TextStyle(
                    color: duration.inMinutes > 5
                        ? ColorPalette.yellow
                        : ColorPalette.red[300],
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen(context)
                        ? AppFonts.baseSize
                        : AppFonts.largeSize,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppBarButton(
              backgroundColor: Colors.white,
              icon: Icon(
                CupertinoIcons.videocam_fill,
                color: ColorPalette.green,
                size: isSmallScreen(context) ? 24 : 32,
              ),
              onPressed: () async {
                if (!videoCallController.canJoinVideoCall(
                    currentMeetingId:
                        meetingsController.currentMeeting.value!.id))
                {
                  // Block entry
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Session Ended"),
                      content: const Text(
                        "This session has already reached the maximum allowed duration.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                  return;
                }
                else
                {
                  final nextId =
                      (chatController.recentMsgEvent.value.messageId ?? 0) + 1;

                  final messageMap = <String, dynamic>{
                    'id': nextId,
                    'chat_id': chatController.chatId!.value,
                    'sender_id': myId,
                    'parent_id': null,
                    'sender_type': consultant,
                    'message': 'incoming call...',
                    'message_type': 'text',
                    'caption': null,
                    'created_at': DateTime.now().toUtc().toIso8601String(),
                    'updated_at': DateTime.now().toUtc().toIso8601String(),
                  };

                  await chatController.triggerPusherEvent(
                      'incoming-call', messageMap);

                  final message = MessageModel.fromJson(messageMap);

                  chatController.handleIncomingCall(message: message);
                }
              }),
          const MoreOptions(),
        ],
      ),
    );
  }
}
