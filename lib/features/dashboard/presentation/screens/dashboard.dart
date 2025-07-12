import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_fab.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/widgets/nav_item.dart';
import 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';
import 'package:tl_consultant/features/journal/presentation/screens/journal_tab.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';
import 'package:tl_consultant/features/profile/presentation/screens/profile_tab.dart';
import 'package:tl_consultant/features/wallet/presentation/screens/wallet_tab.dart';

part 'package:tl_consultant/features/dashboard/presentation/widgets/nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final dashboardController = Get.put(DashboardController());
  final profileController = Get.put(ProfileController());
  final chatController = Get.put(ChatController());
  final meetingsController = Get.put(MeetingsController());

  ClientUser? client;

  @override
  void initState() {
    dashboardController.getMyLocationInfo();
    checkForEmptyProfileInfo(profileController);

    setStatusBarBrightness(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/chat_bg.png'), context);
    super.didChangeDependencies();
  }


  updateDashboardMeetingInfo() async{
    for (var meeting in meetingsController.meetings) {
      if(meeting.id ==1){
        dashboardController.currentMeetingCount.value = 1;
        dashboardController.currentMeetingId.value = meeting.id;

        print("CLIENT_INFO: ${meeting.client.toJson()}");
        client = meeting.client;

        dashboardController.clientId.value = client!.id;
        dashboardController.clientDp.value = client!.avatarUrl;
        dashboardController.clientName.value = client!.displayName;
        dashboardController.currentMeetingST.value = meeting.startAt.formatDate;
        dashboardController.currentMeetingET.value = meeting.endAt.formatDate;
      }

      //TODO: Uncomment this
      // if (meeting.endAt.isAfter(DateTimeExtension.now) &&
      //     (meeting.startAt.isBefore(DateTimeExtension.now) ||
      //         meeting.startAt == DateTimeExtension.now)) {
      //   currentMeetingCount.value = 1;
      //   currentMeetingId.value = meeting.id;
      //   consultantId.value = meeting.consultant.id;
      //   consultantDp.value = meeting.consultant.avatarUrl!;
      //   consultantName.value = meeting.consultant.firstName;
      //   currentMeetingST.value = meeting.startAt.formatDate;
      //   currentMeetingET.value = meeting.endAt.formatDate;
      // }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Completely removes AppBar height
        child: CustomAppBar(
          backgroundColor: (!isSmallScreen(context) && dashboardController.currentIndex.value == 0) ? ColorPalette.white : Colors.grey.shade100,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: isSmallScreen(context) ? CustomFAB(
        onChatTap: () async{
          updateDashboardMeetingInfo();

          if(client != null){
            await chatController.getChatInfo(client: client!);
          }


        },
        dbController: dashboardController,
      ) : null,
      floatingActionButtonLocation: isSmallScreen(context) ? FloatingActionButtonLocation.centerDocked : null,
      bottomNavigationBar: bottomAppBar(context),
      body: isSmallScreen(context) ? dashboardController.pages[dashboardController.currentIndex.value] : large(),
    ));
  }

  BottomAppBar? bottomAppBar(BuildContext context) {
    if(isSmallScreen(context)){
      return BottomAppBar(
        shadowColor: Colors.grey,
        color: ColorPalette.scaffoldColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: displayWidth(context) * 0.025,
        child: BottomNavBar(dashboardController: dashboardController),
      );
    }else{
      return null;
    }
  }

  Widget large(){
    final iconSize = displayWidth(context) * 0.02;
    return Row(
      children: [
        Container(
          width: 80,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          decoration: BoxDecoration(
            color: ColorPalette.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(3, 0),
              ),
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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

              SizedBox(height: 40),

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

              SizedBox(height: 40),

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

              SizedBox(height: 40),

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
       Expanded(child: dashboardController.pages[dashboardController.currentIndex.value])
      ],
    );
  }


}

