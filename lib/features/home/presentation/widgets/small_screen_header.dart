import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_icon_button.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/activity/presentation/screens/notifications.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

class SmallScreenHeader extends StatelessWidget {
  SmallScreenHeader({super.key, required this.activityController});

  final ActivityController activityController;
  final dashboardController = DashboardController.instance;

  static const double _radius = 24;
  static const double _diameter = _radius * 2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(()=>Container(
              width: _diameter,
              height: _diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.grey[100],
              ),
              clipBehavior: Clip.hardEdge,
              child: UserAvatar(size: _diameter, imageUrl: dashboardController.profilePic.value),
            )),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: getGreeting(),
                  size: AppFonts.largeSize,
                  color: ColorPalette.black2,
                  fontFamily: AppFonts.mulishRegular,
                ),
                Obx(()=>CustomText(
                  text: dashboardController.firstName.value,
                  size: AppFonts.largeSize+2,
                  // size: 24,
                  color: ColorPalette.black2,
                  fontFamily: AppFonts.mulishSemiBold,
                ))
              ],
            )
          ],
        ),
        GestureDetector(
            onTap: () {
              Get.toNamed(Routes.ACTIVITY);
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
    );
  }
}
