import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _BG(),
        Column(
          children: [
            // const AppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Title(),
                            const SizedBox(height: 24),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.58,
                              child: Meetings(),
                            ),
                            const SizedBox(height: 32),
                            //TODO: Add edit slots button
                          ],
                        )
                    )
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

class _BG extends StatelessWidget {
  const _BG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.42,
      alignment: Alignment.topCenter,
      child: Container(color: Colors.grey[200]),
    );
  }
}

