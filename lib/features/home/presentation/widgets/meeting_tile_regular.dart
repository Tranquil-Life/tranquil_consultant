part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class MeetingTileRegular extends StatefulWidget {
  final Meeting meeting;
  final bool lastItem;

  const MeetingTileRegular({super.key, required this.meeting, required this.lastItem});

  @override
  State<MeetingTileRegular> createState() => MeetingTileRegularState();
}

class MeetingTileRegularState extends State<MeetingTileRegular> {
  final meetingsController = MeetingsController.instance;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Customize the format
    final formattedDate =
        DateFormat('EEE, dd/MM/yyyy').format(widget.meeting.startAt);
    final startTime = DateFormat('HH:mm').format(widget.meeting.startAt);
    final endTime = DateFormat('HH:mm').format(widget.meeting.endAt);
    final duration = widget.meeting.endAt.difference(widget.meeting.startAt);
    final hours = duration.inHours;
    final minutes = duration.inMinutes;
    final timeRange = "$startTime - $endTime";

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
                imageUrl: widget.meeting.client.avatarUrl,
                source: AvatarSource.url,
                size: 70,
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
                        text: widget.meeting.client.displayName,
                        size: 20,
                        weight: FontWeight.w600,
                        color: ColorPalette.grey[500],
                        fontFamily: AppFonts.mulishSemiBold,
                      ),
                      if (widget.meeting.isExpired)
                        CustomText(
                          text: "Expired ($timeRange)",
                          color: ColorPalette.red,
                          size: 20,
                        )
                      else
                        CustomText(
                          text: "$minutes mins",
                          size: 20,
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
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: formattedDate,
                          size: 16,
                          weight: FontWeight.w400
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    if (widget.meeting.ratedByClient &&
                        !widget.meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.green),
                          CustomText(text: "Rated by client", size: 16,)
                        ],
                      ),
                    if (!widget.meeting.ratedByClient &&
                        widget.meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.yellow),
                          CustomText(text: "Rated by you", size: 16)
                        ],
                      ),
                    if (widget.meeting.ratedByClient &&
                        widget.meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.green),
                          SizedBox(width: 4),
                          SizedBox(child: CustomText(
                            text: "Rated by both sides",
                            size: 16))
                        ],
                      ),
                    if (!widget.meeting.ratedByClient &&
                        !widget.meeting.ratedByTherapist &&
                        widget.meeting.isExpired)
                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => RateConsultationDialog(
                                    selectedRating: index + 1,
                                    meetingsController: meetingsController,
                                    meeting: widget.meeting),
                              );
                            },
                            child: Icon(Icons.star_border_rounded,
                                color: Colors.grey, size: 32,),
                          ),
                        ),
                      ),
                    if (!widget.meeting.isExpired)
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
        if (!widget.lastItem)
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
