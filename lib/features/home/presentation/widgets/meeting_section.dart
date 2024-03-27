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
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
          ],
        ),
        child: Obx(
          () => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your scheduled meetings',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 44,
                    height: 26,
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: ColorPalette.green[800],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        meetingsController.meetings.length.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 19),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: meetingsController.isFirstLoadRunning.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.green,
                        ),
                      )
                    : Scrollbar(
                        child: RefreshIndicator(
                          color: ColorPalette.green,
                          onRefresh: () async => getMeetings(),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ValueListenableBuilder<DateTime>(
                              valueListenable: _timeNotifier,
                              builder: (context, time, child) {
                                if (meetingsController.meetings.isEmpty) {
                                  return const NoMeetingsWidget();
                                }

                                return ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        meetingsController.meetings.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (_, index) {
                                      if (index ==
                                          meetingsController.meetings.length) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                              color: ColorPalette.green),
                                        );
                                      }

                                      return MeetingTile(
                                        meeting: meetingsController
                                            .meetings[index]
                                          ..setIsExpired(_timeNotifier.value),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }
}
