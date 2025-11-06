import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/activity/presentation/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final activityController = ActivityController.instance;

  @override
  void initState() {
    activityController.loadFirstNotifications();
    activityController.getUnread();


    activityController.scrollController = ScrollController()
      ..addListener(() => activityController.loadMoreTransactions());
    super.initState();
  }

  @override
  void dispose() {
    activityController.scrollController.removeListener(() {});
    activityController.page.value = 1;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.scaffoldColor,
      appBar: const CustomAppBar(title: 'Activity'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
            onTap: () => setState(() {}),
            child: GetBuilder<ActivityController>(
              init: ActivityController(),
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _.isFirstLoadRunning.value
                      ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorPalette.green,
                      ))
                      : Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: _.notifications.length,
                        itemBuilder: (context, index) {
                          return NotificationCard(
                            type: _.notifications[index].type.type,
                            body: _.notifications[index].body!,
                            time: _.notifications[index].createdAt!,
                          );
                        },
                      ),
                    ),
                  ),

                  // when the _loadMore function is running
                  if (_.isLoadMoreRunning.value == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.green,
                        ),
                      ),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
