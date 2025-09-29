import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/rate_consultation_dialog.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/home/presentation/widgets/events_section.dart';
import 'package:tl_consultant/features/home/presentation/widgets/explore_perks_widget.dart';
import 'package:tl_consultant/features/home/presentation/widgets/large_screen_header.dart';
import 'package:tl_consultant/features/home/presentation/widgets/no_meetings.dart';
import 'package:tl_consultant/features/home/presentation/widgets/small_screen_header.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

part 'package:tl_consultant/features/home/presentation/widgets/meeting_section.dart';

part 'package:tl_consultant/features/home/presentation/widgets/small/meeting_tile_small.dart';
part 'package:tl_consultant/features/home/presentation/widgets/regular/meeting_tile_regular.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dashboardController = DashboardController.instance;
  final profileController = ProfileController.instance;
  final activityController = ActivityController();
  final meetingsController = Get.put(MeetingsController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            24,
                            isSmallScreen(context) ? 24 : 0,
                            isSmallScreen(context) ? 24 : 0,
                            24),
                        child: Column(
                          children: [
                            isSmallScreen(context)
                                ? SmallScreenHeader(
                                    profileController: profileController,
                                    activityController: activityController)
                                : LargeScreenHeader(
                                    profileController: profileController,
                                    activityController: activityController),
                            const SizedBox(height: 45),
                            Padding(padding: EdgeInsets.only(right: isSmallScreen(context) ? 0 : 24),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Scheduled sessions",
                                        style: TextStyle(
                                            color: ColorPalette.grey[600],
                                            fontSize: isSmallScreen(context) ? 16 : 20,
                                            fontWeight: isSmallScreen(context)
                                                ? FontWeight.w600
                                                : FontWeight.w700),
                                      ),
                                      Text(
                                        "See all",
                                        style: TextStyle(
                                            color: ColorPalette.green,
                                            fontSize: isSmallScreen(context) ? 14 : 16,
                                            fontFamily: AppFonts.mulishRegular,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        (meetingsController.meetings.isEmpty
                                            ? 0.28
                                            : 0.38),
                                    child: Meetings(),
                                  ),
                                  const SizedBox(height: 12),
                                  CustomButton(
                                    onPressed: () async{
                                      var isEmpty = await checkForEmptyProfileInfo();
                                      if(isEmpty){
                                        Get.to(() => EditProfileScreen());
                                      }else{
                                        Get.toNamed(Routes.EDIT_SLOTS);
                                      }
                                    },
                                    showBorder: true,
                                    bgColor: ColorPalette.white,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Set your hours",
                                              style: TextStyle(
                                                  color: ColorPalette.green,
                                                  fontFamily: AppFonts.mulishRegular,
                                                  fontSize: isSmallScreen(context) ? AppFonts.defaultSize : AppFonts.baseSize,
                                                  fontWeight: FontWeight.w600)),
                                          Icon(Icons.keyboard_arrow_right_outlined,
                                              color: ColorPalette.green),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  ExplorePerksWidget(),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Events near you",
                                        style: TextStyle(
                                            color: ColorPalette.grey[600],
                                            fontFamily: AppFonts.mulishRegular,
                                            fontSize: isSmallScreen(context) ? 16 : 20,
                                            fontWeight: isSmallScreen(context)
                                                ? FontWeight.w600
                                                : FontWeight.w700),
                                      ),
                                      Text(
                                        "See all",
                                        style: TextStyle(
                                            color: ColorPalette.green,
                                            fontSize: isSmallScreen(context) ? 14 : 16,
                                            fontFamily: AppFonts.mulishRegular,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  EventsSection(),
                                  SizedBox(height: 40),
                                ],
                              ))
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

// class _BG extends StatelessWidget {
//   const _BG({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FractionallySizedBox(
//       heightFactor: 0.42,
//       alignment: Alignment.topCenter,
//       child: Container(color: ColorPalette.scaffoldColor),
//     );
//   }
// }
