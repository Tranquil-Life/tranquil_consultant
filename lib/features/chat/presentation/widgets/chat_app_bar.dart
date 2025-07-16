part of '../screens/chat_screen.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  final duration = const Duration(minutes: 30);

  AgoraController agoraController = Get.put(AgoraController());

  DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: [
          const SizedBox(width: 8),
          const BackButtonWhite(),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: UserAvatar(
              size: 44,
              imageUrl: dashboardController.clientDp.value,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboardController.clientName.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                Text(
                  TimeFormatter.toReadableString(duration.inMilliseconds),
                  style: TextStyle(
                    color: duration.inMinutes > 5
                        ? ColorPalette.yellow
                        : ColorPalette.red[300],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
              ),
              onPressed: () {
                agoraController.joinAgoraCall();
              }),
          const MoreOptions(),
        ],
      ),
    );
  }
}
