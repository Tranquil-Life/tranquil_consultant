part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  final meetingsController = Get.put(MeetingsController());
  final dashboardController = Get.put(DashboardController());

  final ValueNotifier<DateTime> _timeNotifier = ValueNotifier(DateTime.now());
  ClientUser? clientUser;

  // DateTime
  final now = DateTime.now();

  updateDashboardMeetingInfo() async {
    await Future.delayed(Duration(seconds: 2));

    for (var meeting in meetingsController.meetings) {
      if (meeting.id == 2) {
        dashboardController.currentMeetingCount.value = 1;
        dashboardController.currentMeetingId.value = meeting.id;
        clientUser = meeting.client;

        dashboardController.clientId.value = clientUser!.id!;
        dashboardController.clientDp.value = clientUser!.avatarUrl;
        dashboardController.clientName.value = clientUser!.displayName;
        dashboardController.currentMeetingST.value = meeting.startAt.formatDate;
        dashboardController.currentMeetingET.value = meeting.endAt.formatDate;
      }

      final meetingEnd = meeting.endAt;
      // Difference (will be negative if meetingEnd is in the future)
      final difference = now.difference(meetingEnd);

      if (meeting.ratedByClient) {
        //TODO: if the meeting payment status != paid, call transfer endpoint
      } else if (!meeting.ratedByClient &&
          meeting.ratedByTherapist &&
          (!difference.isNegative && difference.inHours >= 48)) {}

      // if (meeting.endAt.isAfter(DateTimeExtension.now) &&
      //     (meeting.startAt.isBefore(DateTimeExtension.now) ||
      //         meeting.startAt == DateTimeExtension.now)) {
      //   dashboardController.currentMeetingCount.value = 1;
      //   dashboardController.currentMeetingId.value = meeting.id;
      //   dashboardController.clientId.value = meeting.client.id;
      //   dashboardController.clientDp.value = meeting.client.avatarUrl!;
      //   dashboardController.clientName.value = meeting.client.firstName;
      //   dashboardController.currentMeetingST.value = meeting.startAt.formatDate;
      //   dashboardController.currentMeetingET.value = meeting.endAt.formatDate;
      // }
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
                  // return Scrollbar(
                  //   controller: meetingsController.scrollController,
                  //   child: RefreshIndicator(
                  //     color: ColorPalette.green,
                  //     onRefresh: () async => await handleRefresh(),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(right: 10),
                  //       child: ListView.builder(
                  //         controller: meetingsController.scrollController,
                  //         physics: const AlwaysScrollableScrollPhysics(),
                  //         itemCount: meetingsController.meetings.length,
                  //         padding: EdgeInsets.zero,
                  //         itemBuilder: (_, index) {
                  //           return MeetingTile(
                  //             meeting: meetingsController.meetings[index]
                  //               ..setIsExpired(_timeNotifier.value),
                  //             lastItem: index ==
                  //                 meetingsController.meetings.length - 1,
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // );
                }
              }),
            ),
          ],
        ));
  }
}
