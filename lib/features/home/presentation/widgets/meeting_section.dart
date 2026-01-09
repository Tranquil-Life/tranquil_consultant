part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  final meetingsController = MeetingsController.instance;
  final dashboardController = DashboardController.instance;

  final ValueNotifier<DateTime> _timeNotifier = ValueNotifier(DateTime.now());
  ClientUser? clientUser;

  // DateTime
  final now = DateTime.now();

  Future<void> updateDashboardMeetingInfo() async {
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTimeExtension.now;

    // reset first (important)
    dashboardController.currentMeetingCount.value = 0;
    dashboardController.currentMeetingId.value = 0;
    meetingsController.currentMeeting.value = null;

    for (final meeting in meetingsController.meetings) {
      meeting.setIsExpired(now);

      final isOngoing =
          !meeting.isExpired &&
              (meeting.startAt.isBefore(now) || meeting.startAt.isAtSameMomentAs(now)) &&
              (meeting.endAt.isAfter(now) || meeting.endAt.isAtSameMomentAs(now));

      if (isOngoing) {
        dashboardController.currentMeetingCount.value = 1;
        dashboardController.currentMeetingId.value = meeting.id;
        clientUser = meeting.client;
        meetingsController.currentMeeting.value = meeting;
        break; // stop after finding the current meeting
      }
    }
  }

  @override
  void initState() {
    meetingsController.scrollController = ScrollController();

    meetingsController.loadFirstMeetings().then((_) {
      updateDashboardMeetingInfo();
    });

    super.initState();
  }

  Future handleRefresh() async {
    await meetingsController.loadFirstMeetings().then((_) {
      updateDashboardMeetingInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: displayWidth(context),
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 3),
        decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (meetingsController.isFirstLoadRunning.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorPalette.green,
                    ),
                  );
                } else if (meetingsController.meetings.isEmpty) {
                  return const NoMeetingsWidget();
                } else {
                  return RefreshIndicator(
                    color: ColorPalette.green,
                    onRefresh: () async => await handleRefresh(),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ListView.builder(
                        controller: meetingsController.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: meetingsController.meetings.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          return isSmallScreen(context)
                              ? MeetingTileSmall(
                            meeting: meetingsController.meetings[index]
                              ..setIsExpired(_timeNotifier.value),
                            lastItem: index ==
                                meetingsController.meetings.length - 1,
                          )
                              : MeetingTileRegular(
                            meeting: meetingsController.meetings[index]
                              ..setIsExpired(_timeNotifier.value),
                            lastItem: index ==
                                meetingsController.meetings.length - 1,
                          );
                        },
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ));
  }
}
