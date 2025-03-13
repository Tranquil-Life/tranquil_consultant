import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/home/presentation/controllers/event_controller.dart';
import 'package:tl_consultant/features/home/presentation/widgets/event_card.dart';
import 'package:tl_consultant/features/home/presentation/widgets/no_events.dart';

class EventsSection extends StatefulWidget {
  const EventsSection({super.key});

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  EventsController eventsController = Get.put(EventsController());

  final ValueNotifier<DateTime> _timeNotifier = ValueNotifier(DateTime.now());

  getEvents() async {
    //..
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displayWidth(context),
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: eventsController.events.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (eventsController.events.isEmpty) NoEventsWidget()
          else
          Expanded(
              child: eventsController.isFirstLoadRunning.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorPalette.green,
                      ),
                    )
                  : Scrollbar(
                      child: RefreshIndicator(
                        color: ColorPalette.green,
                        onRefresh: () async => getEvents(),
                        child: ValueListenableBuilder<DateTime>(
                          valueListenable: _timeNotifier,
                          builder: (context, time, child) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: eventsController.events.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (_, index) {
                                  print("event: $index");
                                  if (index == eventsController.events.length) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                          color: ColorPalette.green),
                                    );
                                  }

                                  return EventCard(
                                    event: eventsController.events[index]
                                      ..setIsExpired(_timeNotifier.value),
                                  );
                                });
                          },
                        ),
                      ),
                    ))
        ],
      ),
    );
  }
}
