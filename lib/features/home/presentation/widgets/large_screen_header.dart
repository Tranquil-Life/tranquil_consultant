import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_icon_button.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/activity/presentation/screens/notifications.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

import '../../../../core/utils/helpers/svg_elements.dart';

class LargeScreenHeader extends StatelessWidget {
  const LargeScreenHeader(
      {super.key,
      required this.profileController,
      required this.activityController});

  final ProfileController profileController;
  final ActivityController activityController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      padding: EdgeInsets.only(left: 20, right: 60),
      decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(3, 0),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: CircleAvatar(
                    backgroundColor: ColorPalette.grey[100],
                    radius: 30,
                    child: MyAvatarWidget(size: 52 * 2),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getGreeting(),
                    style: TextStyle(
                        fontSize: 24,
                        color: ColorPalette.grey[300],
                        fontFamily: AppFonts.josefinSansRegular),
                  ),
                  Text(
                    profileController.firstNameTEC.text,
                    style: TextStyle(
                        fontSize: 28,
                        color: ColorPalette.black2,
                        fontFamily: AppFonts.josefinSansRegular),
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
                    SvgPicture.asset(SvgElements.svgBellIcon,
                        height: 24, width: 24),
                    if (activityController.count() > 0)
                      Positioned(
                        right: 0,
                        top: -5,
                        child: CountIndicator(activityController.count()),
                      )
                  ],
                ),
              ), showBorder: true,)),
        ],
      ),
    );
  }
}
