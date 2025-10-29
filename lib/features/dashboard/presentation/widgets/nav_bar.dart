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