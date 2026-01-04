import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_fab.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/widgets/nav_item.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

part 'package:tl_consultant/features/dashboard/presentation/widgets/nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final dashboardController = DashboardController.instance;
  final profileController = ProfileController.instance;
  final chatController = ChatController.instance;
  final meetingsController = MeetingsController.instance;

  ClientUser? client;

  bool _pushedEditProfile = false;


  void profileCompletionCheck() async {
    var isEmpty = await checkForEmptyProfileInfo();
    if (isEmpty) {
      Get.toNamed(Routes.EDIT_PROFILE);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dashboardController.getMyLocationInfoCached();
      profileController.restoreUser();

      final isEmpty = await checkForEmptyProfileInfo();
      if (isEmpty && !_pushedEditProfile) {
        _pushedEditProfile = true;
        Get.toNamed(Routes.EDIT_PROFILE);
      }
    });

    setStatusBarBrightness(true);
  }


  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/chat_bg.png'), context);
    super.didChangeDependencies();
  }

  Future<void> updateDashboardMeetingInfo() async {
    for (var meeting in meetingsController.meetings) {
      if (meeting.id == 1) {
        dashboardController.currentMeetingCount.value = 1;
        dashboardController.currentMeetingId.value = meeting.id;

        client = meeting.client;

        meetingsController.currentMeeting.value = meeting;
      }

      //TODO: Uncomment this
      // if (meeting.endAt.isAfter(DateTimeExtension.now) &&
      //     (meeting.startAt.isBefore(DateTimeExtension.now) ||
      //         meeting.startAt == DateTimeExtension.now)) {
      // dashboardController.currentMeetingCount.value = 1;
      // dashboardController.currentMeetingId.value = meeting.id;
      //
      // client = meeting.client;
      //
      // meetingsController.currentMeeting.value = meeting;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: isSmallScreen(context)
              ? PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  // Completely removes AppBar height
                  child: CustomAppBar(
                    backgroundColor: (!isSmallScreen(context) &&
                            dashboardController.currentIndex.value == 0)
                        ? ColorPalette.white
                        : Colors.grey.shade100,
                  ),
                )
              : null,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey.shade100,
          floatingActionButton: isSmallScreen(context)
              ? CustomFAB(
                  onChatTap: () async {
                    await updateDashboardMeetingInfo();

                    if (client != null) {
                      await chatController.getChatInfo(client: client!);
                    }else{
                      CustomSnackBar.showSnackBar(context: Get.context, message: "You have no ongoing session", backgroundColor: ColorPalette.blue);
                    }
                  },
                  dbController: dashboardController,
                )
              : null,
          floatingActionButtonLocation: isSmallScreen(context)
              ? FloatingActionButtonLocation.centerDocked
              : null,
          bottomNavigationBar: bottomAppBar(context),
          body: isSmallScreen(context)
              ? dashboardController
                  .pages[dashboardController.currentIndex.value]
              : large(),
        ));
  }

  BottomAppBar? bottomAppBar(BuildContext context) {
    if (isSmallScreen(context)) {
      return BottomAppBar(
        shadowColor: Colors.grey,
        color: ColorPalette.scaffoldColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: displayWidth(context) * 0.025,
        child: BottomNavBar(dashboardController: dashboardController),
      );
    } else {
      return null;
    }
  }

  Widget large() {
    final iconSize = 0.0;
    return Row(
      children: [
        Container(
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(color: ColorPalette.white, boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(3, 0),
              ),
            ]),
            child:

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BuildNavItem(
                  index: 0,
                  icon: dashboardController.isSelected(0)
                      ? SvgElements.svgHomeActive
                      : SvgElements.svgHomeInactive,
                  label: 'Home',
                  size: displaySize(context),
                  iconSize: iconSize,
                  isSelected: dashboardController.isSelected(0),
                  dashboardController: dashboardController,
                  onTap: () => dashboardController.updateIndex(0),
                ),
                SizedBox(height: 40),
                BuildNavItem(
                  index: 1,
                  icon: dashboardController.isSelected(1)
                      ? SvgElements.svgNotesActive
                      : SvgElements.svgNotesInactive,
                  label: 'Notes',
                  size: displaySize(context),
                  iconSize: iconSize,
                  isSelected: dashboardController.isSelected(1),
                  dashboardController: dashboardController,
                  onTap: () => dashboardController.updateIndex(1),
                ),
                SizedBox(height: 40),
                BuildNavItem(
                  index: 2,
                  icon: dashboardController.isSelected(2)
                      ? SvgElements.svgChat
                      : SvgElements.svgChat,
                  label: 'Chat',
                  size: displaySize(context),
                  iconSize: iconSize,
                  isSelected: dashboardController.isSelected(2),
                  dashboardController: dashboardController,
                  onTap: () async{
                    await updateDashboardMeetingInfo();

                    if (client != null) {
                      await chatController.getChatInfo(client: client);
                      dashboardController.updateIndex(2);
                      await meetingsController.startMeeting();
                    }else{
                      CustomSnackBar.showSnackBar(context: Get.context, message: "You have no ongoing session", backgroundColor: ColorPalette.blue);
                    }
                  },
                ),
                SizedBox(height: 40),
                BuildNavItem(
                  index: 3,
                  icon: dashboardController.isSelected(3)
                      ? SvgElements.svgWalletActive
                      : SvgElements.svgWalletInactive,
                  label: 'Wallet',
                  size: displaySize(context),
                  iconSize: iconSize,
                  isSelected: dashboardController.isSelected(3),
                  dashboardController: dashboardController,
                  onTap: () => dashboardController.updateIndex(3),
                ),
                SizedBox(height: 40),
                BuildNavItem(
                  index: 4,
                  icon: dashboardController.isSelected(4)
                      ? SvgElements.svgMoreActive
                      : SvgElements.svgMoreInactive,
                  label: 'More',
                  size: displaySize(context),
                  iconSize: iconSize,
                  isSelected: dashboardController.isSelected(4),
                  dashboardController: dashboardController,
                  onTap: () => dashboardController.updateIndex(4),
                ),
              ],
            ),
            ),
        Expanded(
            child: dashboardController
                .largePages[dashboardController.currentIndex.value])
      ],
    );
  }
}
