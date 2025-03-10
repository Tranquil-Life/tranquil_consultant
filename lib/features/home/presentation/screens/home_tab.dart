import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/activity/presentation/screens/notifications.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';

import 'package:tl_consultant/core/global/custom_icon_button.dart';
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
                                              color: ColorPalette.black2),
                                        ),
                                        Text(
                                          profileController.firstNameTEC.text,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: ColorPalette.black2),
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
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "See all",
                                  style: TextStyle(
                                      color: ColorPalette.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 17),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.38,
                              child: Meetings(),
                            ),
                            const SizedBox(height: 28),
                            Container(
                                child: Stack(
                                  children: [
                                    Image.asset("assets/images/upscale.png",  fit: BoxFit.cover,),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Explore perks prepared to help you become a  mental health expert",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorPalette.white),
                                          ),

                                         SizedBox(
                                           width: 160,
                                           child:  CustomButton(bgColor: ColorPalette.white,onPressed: (){}, child:  Center(
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                               Text("Get started",  style: TextStyle(
                                                   color: ColorPalette.black),), Icon(Icons.keyboard_arrow_right_outlined, color: ColorPalette.black,)
                                             ],),
                                           )),
                                         )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //       blurRadius: 2, color: Colors.black12, offset: Offset(0, 1)),
                                  // ],
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
