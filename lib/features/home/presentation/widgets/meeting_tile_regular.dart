part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class MeetingTileRegular extends StatelessWidget {
  const MeetingTileRegular({super.key, required this.meeting, required this.lastItem, required this.now});

  final Meeting meeting;
  final bool lastItem;
  final DateTime now;
  
  @override
  Widget build(BuildContext context) {
    final isExpired = meeting.endAt.isBefore(now); // or your exact rule

    final startTime = DateFormat('HH:mm').format(meeting.startAt);
    final endTime = DateFormat('HH:mm').format(meeting.endAt);
    final duration = meeting.endAt.difference(meeting.startAt);
    final minutes = duration.inMinutes;
    final timeRange = "$startTime - $endTime";
    final formattedDate = DateFormat('EEE, dd/MM/yyyy').format(meeting.startAt);

    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Color(0xffE4E4E4)),
              ),
              child: UserAvatar(
                imageUrl: meeting.client.avatarUrl,
                source: AvatarSource.url,
                // size: 70,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: displayWidth(context), // or double.infinity
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: meeting.client.displayName,
                            size: 16,
                            // size: 20,
                            weight: FontWeight.w600,
                            color: ColorPalette.grey[500],
                            fontFamily: AppFonts.mulishSemiBold,
                          ),
                          if (isExpired)
                            CustomText(
                              text: "Expired ($timeRange)",
                              color: ColorPalette.red,
                              // size: 20,
                            )
                          else
                            CustomText(
                              text: "$minutes mins",
                              // size: 20,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              SvgElements.svgCalendar,
                              height: 14,
                              width: 14,
                              // height: 20,
                              // width: 20,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                                text: formattedDate,
                                size: 13,
                                // size: 16,
                                weight: FontWeight.w400
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        if (meeting.ratedByClient &&
                            !meeting.ratedByTherapist)
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: ColorPalette.green),
                              CustomText(text: "Rated by client")
                            ],
                          ),
                        if (!meeting.ratedByClient &&
                            meeting.ratedByTherapist)
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: ColorPalette.yellow),
                              CustomText(text: "Rated by you")
                            ],
                          ),
                        if (meeting.ratedByClient &&
                            meeting.ratedByTherapist)
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: ColorPalette.green),
                              SizedBox(width: 4),
                              SizedBox(child: CustomText(
                                text: "Rated by both sides",
                              ))
                            ],
                          ),
                        if (!meeting.ratedByClient &&
                            !meeting.ratedByTherapist &&
                            isExpired)
                          Row(
                            children: List.generate(
                              5,
                                  (index) => GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => RateConsultationDialog(
                                        selectedRating: index + 1,
                                        meetingsController: MeetingsController.instance,
                                        meeting: meeting),
                                  );
                                },
                                child: Icon(Icons.star_border_rounded,
                                  color: Colors.grey,
                                  // size: 32,
                                ),
                              ),
                            ),
                          ),
                        if (!isExpired)
                          Row(
                            children: [
                              SvgPicture.asset(
                                SvgElements.svgClock,
                                height: 14,
                                width: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                timeRange,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
        if (!lastItem)
          Container(
            height: 0.2,
            margin: EdgeInsets.only(top: 12, bottom: 12),
            width: displayWidth(context),
            color: ColorPalette.grey[700],
          ),
      ],
    );
  }
}


