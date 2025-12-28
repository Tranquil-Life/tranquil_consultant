import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';

class IncomingCallView extends StatelessWidget {
  IncomingCallView({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.clientDp,
    this.userType,
  });

  final int clientId;
  final String clientName;
  final String clientDp;
  final String? userType;

  final videoCallController = VideoCallController.instance;
  final chatController = ChatController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: displayHeight(context),
            width: displayWidth(context),
            child: Image.network(
              clientDp,
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, __, ___) => Center(
                child: SizedBox(
                  width: displayWidth(context) * 0.7,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      TranquilIcons.profile,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (userType != consultant)
            Container(
                margin: EdgeInsets.only(top: 100),
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      clientName,
                      style: TextStyle(
                          color: ColorPalette.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "is calling...",
                      style: TextStyle(color: ColorPalette.white, fontSize: 20),
                    )
                  ],
                ))
          else
            Container(
                margin: EdgeInsets.only(top: 100),
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Calling",
                      style: TextStyle(color: ColorPalette.white, fontSize: 20),
                    ),
                    Text(
                      clientName,
                      style: TextStyle(
                          color: ColorPalette.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )),
          if (userType != consultant)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final nextId =
                              (chatController.recentMsgEvent.value.messageId ?? 0) +
                                  1;

                          final messageMap = <String, dynamic>{
                            'id': nextId,
                            'chat_id': chatController.chatId!.value,
                            'sender_id': myId,
                            'parent_id': null,
                            'sender_type': consultant,
                            'message': accepted,
                            'message_type': 'text',
                            'caption': null,
                            'created_at': DateTime.now().toUtc().toIso8601String(),
                            'updated_at': DateTime.now().toUtc().toIso8601String(),
                          };

                          await chatController.triggerPusherEvent(
                            accepted,
                            messageMap,
                          );

                          Get.back();

                          await Future.delayed(Duration(seconds: 1));

                          await videoCallController.navigateToCallView();
                        },
                        child: PulsingCallButton(),
                      ),
                      SizedBox(width: 24),
                      GestureDetector(
                        onTap: () async{
                          final nextId =
                              (chatController.recentMsgEvent.value.messageId ?? 0) +
                                  1;

                          final messageMap = <String, dynamic>{
                            'id': nextId,
                            'chat_id': chatController.chatId!.value,
                            'sender_id': myId,
                            'parent_id': null,
                            'sender_type': consultant,
                            'message': declined,
                            'message_type': 'text',
                            'caption': null,
                            'created_at': DateTime.now().toUtc().toIso8601String(),
                            'updated_at': DateTime.now().toUtc().toIso8601String(),
                          };

                          await chatController.triggerPusherEvent(
                            declined,
                            messageMap,
                          );

                          Get.back();

                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.red,
                          ),
                          child: const Icon(Icons.call_end,
                              color: Colors.white, size: 30),
                        ),
                      ),
                    ],
                  )
              ),
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: GestureDetector(
                  onTap: () async{
                    final nextId =
                        (chatController.recentMsgEvent.value.messageId ?? 0) +
                            1;

                    final messageMap = <String, dynamic>{
                      'id': nextId,
                      'chat_id': chatController.chatId!.value,
                      'sender_id': myId,
                      'parent_id': null,
                      'sender_type': consultant,
                      'message': cancelled,
                      'message_type': 'text',
                      'caption': null,
                      'created_at': DateTime.now().toUtc().toIso8601String(),
                      'updated_at': DateTime.now().toUtc().toIso8601String(),
                    };

                    await chatController.triggerPusherEvent(
                      cancelled,
                      messageMap,
                    );

                    Get.back();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.red,
                    ),
                    child: const Icon(Icons.call_end,
                        color: Colors.white, size: 40),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PulsingCallButton extends StatefulWidget {
  const PulsingCallButton({super.key});

  @override
  State<PulsingCallButton> createState() => _PulsingCallButtonState();
}

class _PulsingCallButtonState extends State<PulsingCallButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100 * _scaleAnimation.value,
              height: 100 * _scaleAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.green,
              ),
              child: const Icon(Icons.videocam, color: Colors.white, size: 40),
            ),
          ],
        );
      },
    );
  }
}
