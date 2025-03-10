part of 'package:tl_consultant/features/dashboard/presentation/screens/dashboard.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.dashboardController});

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    final iconSize = displayWidth(context) * 0.06;

    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: displayWidth(context) * 0.05,
        ),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildNavItem(
                        index: 0,
                        icon: dashboardController.isSelected(0) ? SvgElements.svgHomeActive : SvgElements.svgHomeInactive,
                        label: 'Home',
                        size: displaySize(context),
                        iconSize: iconSize,
                        isSelected: dashboardController.isSelected(0),
                        dashboardController: dashboardController,
                        onTap: () => dashboardController.updateIndex(0),
                      ),
                      BuildNavItem(
                        index: 1,
                        icon: dashboardController.isSelected(1) ? SvgElements.svgNotesActive : SvgElements.svgNotesInactive,
                        label: 'Notes',
                        size: displaySize(context),
                        iconSize: iconSize,
                        isSelected: dashboardController.isSelected(1),
                        dashboardController: dashboardController,
                        onTap: () => dashboardController.updateIndex(1),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: displayWidth(context) * 0.2),

                // Right-side navigation items
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildNavItem(
                        index: 2,
                        icon: dashboardController.isSelected(2) ? SvgElements.svgWalletActive : SvgElements.svgWalletInactive,
                        label: 'Wallet',
                        size: displaySize(context),
                        iconSize: iconSize,
                        isSelected: dashboardController.isSelected(2),
                        dashboardController: dashboardController,
                        onTap: () => dashboardController.updateIndex(2),
                      ),
                      BuildNavItem(
                        index: 3,
                        icon: dashboardController.isSelected(3) ? SvgElements.svgMoreActive : SvgElements.svgMoreInactive,
                        label: 'More',
                        size: displaySize(context),
                        iconSize: iconSize,
                        isSelected: dashboardController.isSelected(3),
                        dashboardController: dashboardController,
                        onTap: () => dashboardController.updateIndex(3),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

/*
Stack(
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
                          checkForEmptyProfileInfo(profileController);
                        },
                      ),
                      Item(
                        label: 'Wallet',
                        iconData: TranquilIcons.wallet,
                        isSelected: dashboardController.currentIndex.value == 1,
                        onTap: () async {
                          await dashboardController.onTap(1);
                          checkForEmptyProfileInfo(profileController);
                        },
                      ),
                      const SizedBox(width: 32),
                      Item(
                        label: 'Notes',
                        iconData: TranquilIcons.view_note,
                        isSelected: dashboardController.currentIndex.value == 2,
                        onTap: () async {
                          await dashboardController.onTap(2);
                          checkForEmptyProfileInfo(profileController);
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
                try {
                  if (chatController.loadingChatRoom.value == false &&
                      dashboardController.currentMeetingCount.value == 1) {
                    await chatController.getChatInfo();
                  } else {
                    print(chatController.loadingChatRoom.value);
                  } // Additional code...
                } catch (error) {
                  print('Error during onTap: $error');
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Obx(() => Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.white,
                            border: Border.all(width: 7, color: Colors.white),
                          ),
                          child: chatController.loadingChatRoom.value
                              ? const CircularProgressIndicator(
                                  color: ColorPalette.white)
                              : const Icon(
                                  TranquilIcons.messages,
                                  color: Colors.white,
                                  size: 32,
                                )),
                      chatController.loadingChatRoom.value
                          ? SizedBox()
                          : Positioned(
                              top: 6,
                              right: 4,
                              child: SizedBox.square(
                                dimension: 28,
                                child: CountIndicator(dashboardController
                                    .currentMeetingCount.value),
                              )),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
* */
