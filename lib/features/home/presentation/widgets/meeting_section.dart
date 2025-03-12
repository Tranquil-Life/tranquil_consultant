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

  getMeetings() async {
    await meetingsController.loadFirstMeetings();

    for (var meeting in meetingsController.meetings) {
      if (meeting.endAt.isAfter(DateTimeExtension.now) &&
          (meeting.startAt.isBefore(DateTimeExtension.now) ||
              meeting.startAt == DateTimeExtension.now)) {
        dashboardController.currentMeetingCount.value = 1;
        dashboardController.currentMeetingId.value = meeting.id;
        dashboardController.clientId.value = meeting.client.id;
        dashboardController.clientDp.value = meeting.client.avatarUrl!;
        dashboardController.clientName.value = meeting.client.firstName;
        dashboardController.currentMeetingST.value = meeting.startAt.formatDate;
        dashboardController.currentMeetingET.value = meeting.endAt.formatDate;
      }
    }
  }

  @override
  void initState() {
    getMeetings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future handleRefresh() async {
    getMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: displayWidth(context),
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 3),
        decoration: BoxDecoration(
          color: Colors.white,
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
                  return Scrollbar(
                    child: RefreshIndicator(
                      color: ColorPalette.green,
                      onRefresh: () async => getMeetings(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: meetingsController.meetings.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) {
                            return MeetingTile(
                              meeting: meetingsController.meetings[index]
                                ..setIsExpired(_timeNotifier.value),
                            );
                          },
                        ),
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
