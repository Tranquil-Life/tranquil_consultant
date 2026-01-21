part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class MeetingTileSmall extends StatelessWidget {
  const MeetingTileSmall({
    super.key,
    required this.meeting,
    required this.lastItem,
    required this.now,
  });

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
                      Text(
                        meeting.client.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.grey[500],
                          fontFamily: AppFonts.mulishSemiBold,
                        ),
                      ),
                      if (isExpired)
                        Text(
                          "Expired ($timeRange)",
                          style: TextStyle(color: ColorPalette.red),
                        )
                      else
                        Text(
                          "$minutes mins",
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    SvgPicture.asset(
                      SvgElements.svgCalendar,
                      height: 14,
                      width: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Spacer(),

                    if (meeting.ratedByClient &&
                        !meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.green),
                          CustomText(text: "Rated by client")
                        ],
                      ),

                    if (!meeting.ratedByClient && meeting.ratedByTherapist)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                              text: "Rated by you", size: AppFonts.smallSize),
                          SizedBox(width: 4),
                          Icon(Icons.check_circle,
                              color: ColorPalette.yellow, size: 16),
                        ],
                      ),
                    if (meeting.ratedByClient && meeting.ratedByTherapist)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "Rated by \nboth sides",
                            size: 12,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.check_circle,
                              color: ColorPalette.green, size: 16),
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
                                color: Colors.grey),
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
                )
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
