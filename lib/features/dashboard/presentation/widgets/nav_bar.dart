part of 'package:tl_consultant/features/dashboard/presentation/screens/dashboard.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final dashboardController = Get.put(DashboardController());
  final notesController = Get.put(NotesController());
  final chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 2),
          child: SafeArea(
              top: false,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Item(
                        label: 'Home',
                        iconData: TranquilIcons.home,
                        isSelected: dashboardController.currentIndex.value == 0,
                        onTap: () async {
                          await dashboardController.onTap(0);
                        },
                      ),
                      Item(
                        label: 'Wallet',
                        iconData: TranquilIcons.wallet,
                        isSelected: dashboardController.currentIndex.value == 1,
                        onTap: () async {
                          await dashboardController.onTap(1);
                        },
                      ),
                      const SizedBox(width: 32),
                      Item(
                        label: 'Notes',
                        iconData: TranquilIcons.view_note,
                        isSelected: dashboardController.currentIndex.value == 2,
                        onTap: () async {
                          await dashboardController.onTap(2);
                        },
                      ),
                      Item(
                        label: 'Profile',
                        iconData: TranquilIcons.profile,
                        isSelected: dashboardController.currentIndex.value == 3,
                        onTap: () async => await dashboardController.onTap(3),
                      ),
                    ],
                  ))),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: SafeArea(
            top: false,
            child: GestureDetector(
              onTap: () async {
                await chatController.getChatInfo();
              },
              behavior: HitTestBehavior.opaque,
              child: Obx(() => Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.green[800],
                          border: Border.all(width: 7, color: Colors.white),
                        ),
                        child: const Icon(
                          TranquilIcons.messages,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      Positioned(
                          top: 6,
                          right: 4,
                          child: SizedBox.square(
                            dimension: 28,
                            child: CountIndicator(DashboardController
                                .instance.currentMeetingCount.value),
                          ))
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
