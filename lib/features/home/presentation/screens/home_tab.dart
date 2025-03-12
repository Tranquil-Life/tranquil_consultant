import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/activity/presentation/screens/notifications.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';

import 'package:tl_consultant/core/global/custom_icon_button.dart';
import 'package:tl_consultant/features/home/presentation/widgets/events_section.dart';
import 'package:tl_consultant/features/home/presentation/widgets/no_meetings.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

part 'package:tl_consultant/features/home/presentation/widgets/title_section.dart';

part 'package:tl_consultant/features/home/presentation/widgets/meeting_section.dart';

part 'package:tl_consultant/features/home/presentation/widgets/meeting_card.dart';

part 'package:tl_consultant/features/home/presentation/widgets/meeting_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final dashboardController = Get.put(DashboardController());
  final profileController = Get.put(ProfileController());
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
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: ColorPalette.grey[100],
                                      radius: 24,
                                      child: MyAvatarWidget(size: 52 * 2),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getGreeting(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ColorPalette.black2, fontFamily: AppFonts.josefinSansRegular),
                                        ),
                                        Text(
                                          profileController.firstNameTEC.text,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: ColorPalette.black2, fontFamily: AppFonts.josefinSansRegular),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Get.to(NotificationScreen());
                                    },
                                    child: CustomIconButton(
                                        icon: Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          SvgPicture.asset(
                                              SvgElements.svgBellIcon,
                                              height: 22,
                                              width: 22),
                                          if (activityController.count() > 0)
                                            Positioned(
                                              right: 0,
                                              top: -5,
                                              child: CountIndicator(
                                                  activityController.count()),
                                            )
                                        ],
                                      ),
                                    ))),
                              ],
                            ),
                            const SizedBox(height: 45),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Scheduled sessions",
                                  style: TextStyle(
                                      color: ColorPalette.grey[600],
                                      fontSize: 16,
                                      fontFamily: AppFonts.mulishRegular,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "See all",
                                  style: TextStyle(
                                      color: ColorPalette.green,
                                      fontSize: 14,
                                      fontFamily: AppFonts.mulishRegular,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * (meetingsController.meetings.isEmpty ? 0.28 : 0.38),
                              child: Meetings(),
                            ),
                            const SizedBox(height: 12),
                            
                            CustomButton(onPressed: (){
                              Get.toNamed(Routes.EDIT_SLOTS);
                            },
                              showBorder: true,
                              bgColor: ColorPalette.white,
                              child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Text("Set your hours", style: TextStyle(color: ColorPalette.green, fontFamily: AppFonts.mulishRegular, fontWeight: FontWeight.w600)),
                                Icon(Icons.keyboard_arrow_right_outlined, color: ColorPalette.green),
                              ],),
                            ),),

                            const SizedBox(height: 28),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Image.asset("assets/images/upscale.png",  fit: BoxFit.fill, height: 140),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                        bottom: 0,
                                        child:
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Explore perks prepared to help you \nbecome a mental health expert",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorPalette.white, fontFamily: AppFonts.mulishRegular, fontWeight: FontWeight.w600),
                                          ),

                                          const SizedBox(height: 12),

                                          SizedBox(
                                            width: 160,
                                            height: 40,
                                            child:  CustomButton(bgColor: ColorPalette.white,onPressed: (){}, child:  Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Get started",  style: TextStyle(
                                                      color: ColorPalette.black, fontSize: 14, fontFamily: AppFonts.mulishRegular, fontWeight: FontWeight.w600),), Icon(Icons.keyboard_arrow_right_outlined, color: ColorPalette.black,)
                                                ],),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ))
                                  ],
                                )),

                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Events near you",
                                  style: TextStyle(
                                      color: ColorPalette.grey[600],
                                      fontSize: 16,
                                      fontFamily: AppFonts.mulishRegular,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "See all",
                                  style: TextStyle(
                                      color: ColorPalette.green,
                                      fontSize: 14,
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
