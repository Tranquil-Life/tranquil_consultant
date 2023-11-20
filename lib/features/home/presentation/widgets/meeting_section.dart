part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class Meetings extends StatefulWidget {
  @override
  State<Meetings> createState() => MeetingsState();
}

class MeetingsState extends State<Meetings> {
  ConsultationController consultationController = ConsultationController();

  //Stream timeListener = dateTimer;
  StreamSubscription<DateTime>? dtStreamSubscription;

  final ValueNotifier<DateTime> _timeNotifier = ValueNotifier(DateTime.now());

  getMeetings() async{
    consultationController.getMeetings();
  }

  @override
  void initState() {
    getMeetings();

    LaravelEcho.init(token: userDataStore.user['auth_token']);

    super.initState();
  }

  @override
  void dispose() {
    try {
      consultationController.meetingsStreamController.close();

      dtStreamSubscription!.cancel();
    } catch (e) {
      log("DISPOSE: Error: $e");
    }
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
        child: Column(
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
                    child: Obx(()=>
                        Text(
                          consultationController.meetingsCount.value.toString() ?? '--',
                          style:
                          const TextStyle(color: Colors.white, fontSize: 19),
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
                child: StreamBuilder<Map<String, dynamic>>(
                    stream: consultationController.meetingsStream,
                    builder: ( context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }else{
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(color: ColorPalette.green,),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (!snapshot.hasData || (snapshot.data!["meetings"] is List && (snapshot.data!["meetings"] as List).isEmpty)) {
                              return NoMeetingsWidget();
                            }
                            else {
                              List<Meeting> meetings = snapshot.data!['meetings'];

                              return Scrollbar(
                                  child: RefreshIndicator(
                                    color: ColorPalette.green,
                                    onRefresh: () async => getMeetings(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ValueListenableBuilder<DateTime>(
                                        valueListenable: _timeNotifier,
                                        builder: (context, time, child) {
                                          return ListView.builder(
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            itemCount: meetings.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (_, index) => MeetingTile(
                                                meeting: meetings[index]
                                                  ..setIsExpired(_timeNotifier.value)),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                              );

                            }
                          case ConnectionState.none:
                          default:
                            return const Center(
                              child: CircularProgressIndicator(color: ColorPalette.green,),
                            );
                        }
                      }
                    })

            ),
          ],
        )
    );
  }
}
