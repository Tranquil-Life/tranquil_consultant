import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await dashboardController.getMyLocationInfoCached(force: false);
      dashboardController.restoreUserInfo();

      ///CHECK IF FOR EMPTY PROFILE INFO - Only push to edit profile if the user is logging in for the first time or has not completed their profile. This is determined by checking if the profile info is empty and if we have already pushed to the edit profile screen during this session.
      // final isEmpty = await checkForEmptyProfileInfo();
      // if (isEmpty && !_pushedEditProfile) {
      //   _pushedEditProfile = true;
      //   Get.toNamed(Routes.EDIT_PROFILE);
      // }
    });

    setStatusBarBrightness(true);
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/chat_bg.png'), context);
    super.didChangeDependencies();
  }

  Future<void> updateDashboardMeetingInfo() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTimeExtension.now;

    dashboardController.currentMeetingCount.value = 0;
    dashboardController.currentMeetingId.value = 0;
    meetingsController.currentMeeting.value = null;
    client = null;

    for (final meeting in meetingsController.meetings) {
      meeting.setIsExpired(now);

      final startAt = meeting.startAt;
      final endAt = meeting.endAt;

      final isOngoing =
          !meeting.isExpired &&
              !startAt.isAfter(now) &&
              !endAt.isBefore(now);

      if (isOngoing) {
        dashboardController.currentMeetingCount.value = 1;
        dashboardController.currentMeetingId.value = meeting.id;

        // only assign if this is a proper Dart model object
        client = meeting.client;

        meetingsController.currentMeeting.value = meeting;
        break;
      }

      //TODO: Temporary fix for testing purposes
      // if (meeting.id == 5) {
      //   dashboardController.currentMeetingCount.value = 1;
      //   dashboardController.currentMeetingId.value = meeting.id;
      //   client = meeting.client;
      //   meetingsController.currentMeeting.value = meeting;
      // }

    }
  }


  @override
  Widget build(BuildContext context) {
    final isSmall = isSmallScreen(context);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final maxIndex = (isSmall
          ? dashboardController.pages.length
          : dashboardController.largePages.length) -
          1;

      if (dashboardController.currentIndex.value > maxIndex) {
        dashboardController.currentIndex.value = maxIndex;
      }

      if (!isSmall && dashboardController.currentIndex.value == 2) {
        dashboardController.currentIndex.value = 3;
      } else if (isSmall && dashboardController.currentIndex.value == 3) {
        dashboardController.currentIndex.value = 2;
      }
    });


    return Obx(() {
      final currentIndex = dashboardController.currentIndex.value;

      return Scaffold(
        appBar: isSmall
            ? PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: CustomAppBar(
            backgroundColor: Colors.grey.shade100,
          ),
        )
            : null,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        floatingActionButton: isSmall
            ? CustomFAB(
          onChatTap: () async {
            await updateDashboardMeetingInfo();

            if (client != null) {
              await chatController.getChatInfo(client: client!);
              await meetingsController.startMeeting();
            } else {
              CustomSnackBar.neutralSnackBar(
                "You have no ongoing session",
              );
            }
          },
          dbController: dashboardController,
        )
            : null,
        floatingActionButtonLocation: isSmall
            ? FloatingActionButtonLocation.centerDocked
            : null,
        bottomNavigationBar: bottomAppBar(context),
        body: isSmall
            ? dashboardController.pages[currentIndex]
            : large(),
      );
    });
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          decoration: BoxDecoration(
            color: ColorPalette.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(3, 0),
              ),
            ],
          ),
          child: Column(
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
                onTap: () async {
                  await updateDashboardMeetingInfo();

                  //TODO: Remember to uncomment for production
                  if (client != null) {
                    await chatController.getChatInfo(client: client);
                    dashboardController.updateIndex(2);
                    await meetingsController.startMeeting();
                  } else {
                    CustomSnackBar.neutralSnackBar(
                        "You have no ongoing session");
                  }

                  //TODO: The below code is for testing purposes only
                  // await chatController.getChatInfo(client: client);
                  // dashboardController.updateIndex(2);
                  // await meetingsController.startMeeting();
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
              .largePages[dashboardController.currentIndex.value],
        ),
      ],
    );
    // return Row(
    //   children: [
    //     Container(
    //       width: 120,
    //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
    //       decoration: BoxDecoration(color: ColorPalette.white, boxShadow: [
    //         BoxShadow(
    //           blurRadius: 4,
    //           color: Colors.black12,
    //           offset: Offset(3, 0),
    //         ),
    //       ]),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           BuildNavItem(
    //             index: 0,
    //             icon: dashboardController.isSelected(0)
    //                 ? SvgElements.svgHomeActive
    //                 : SvgElements.svgHomeInactive,
    //             label: 'Home',
    //             size: displaySize(context),
    //             iconSize: iconSize,
    //             isSelected: dashboardController.isSelected(0),
    //             dashboardController: dashboardController,
    //             onTap: () => dashboardController.updateIndex(0),
    //           ),
    //           SizedBox(height: 40),
    //           BuildNavItem(
    //             index: 1,
    //             icon: dashboardController.isSelected(1)
    //                 ? SvgElements.svgNotesActive
    //                 : SvgElements.svgNotesInactive,
    //             label: 'Notes',
    //             size: displaySize(context),
    //             iconSize: iconSize,
    //             isSelected: dashboardController.isSelected(1),
    //             dashboardController: dashboardController,
    //             onTap: () => dashboardController.updateIndex(1),
    //           ),
    //           SizedBox(height: 40),
    //           BuildNavItem(
    //             index: 2,
    //             icon: dashboardController.isSelected(2)
    //                 ? SvgElements.svgChat
    //                 : SvgElements.svgChat,
    //             label: 'Chat',
    //             size: displaySize(context),
    //             iconSize: iconSize,
    //             isSelected: dashboardController.isSelected(2),
    //             dashboardController: dashboardController,
    //             onTap: () async {
    //               await updateDashboardMeetingInfo();
    //
    //               //TODO: Remember to uncomment for production
    //               if (client != null) {
    //                 await chatController.getChatInfo(client: client);
    //                 dashboardController.updateIndex(2);
    //                 await meetingsController.startMeeting();
    //               } else {
    //                 CustomSnackBar.neutralSnackBar(
    //                     "You have no ongoing session");
    //               }
    //
    //               //TODO: The below code is for testing purposes only
    //               // await chatController.getChatInfo(client: client);
    //               // dashboardController.updateIndex(2);
    //               // await meetingsController.startMeeting();
    //             },
    //           ),
    //           SizedBox(height: 40),
    //           BuildNavItem(
    //             index: 3,
    //             icon: dashboardController.isSelected(3)
    //                 ? SvgElements.svgWalletActive
    //                 : SvgElements.svgWalletInactive,
    //             label: 'Wallet',
    //             size: displaySize(context),
    //             iconSize: iconSize,
    //             isSelected: dashboardController.isSelected(3),
    //             dashboardController: dashboardController,
    //             onTap: () => dashboardController.updateIndex(3),
    //           ),
    //           SizedBox(height: 40),
    //           BuildNavItem(
    //             index: 4,
    //             icon: dashboardController.isSelected(4)
    //                 ? SvgElements.svgMoreActive
    //                 : SvgElements.svgMoreInactive,
    //             label: 'More',
    //             size: displaySize(context),
    //             iconSize: iconSize,
    //             isSelected: dashboardController.isSelected(4),
    //             dashboardController: dashboardController,
    //             onTap: () => dashboardController.updateIndex(4),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Expanded(
    //         child: dashboardController
    //             .largePages[dashboardController.currentIndex.value])
    //   ],
    // );
  }
}
