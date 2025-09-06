part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class MeetingTile extends StatefulWidget {
  final Meeting meeting;
  final bool lastItem;

  const MeetingTile({super.key, required this.meeting, required this.lastItem});

  @override
  State<MeetingTile> createState() => MeetingTileState();
}

class MeetingTileState extends State<MeetingTile> {
  final meetingsController = MeetingsController.instance;


  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Customize the format
    final formattedDate =
        DateFormat('EEE, dd/MM/yyyy').format(widget.meeting.startAt);
    final startTime = DateFormat('HH:mm').format(widget.meeting.startAt);
    final endTime = DateFormat('HH.mm').format(widget.meeting.endAt);
    final timeRange = "$startTime - $endTime";

    final startText = dateFormat.format(widget.meeting.startAt);
    final endText = dateFormat.format(widget.meeting.endAt);

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
                        widget.meeting.client.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.grey[500],
                          fontFamily: AppFonts.mulishSemiBold,
                        ),
                      ),
                      if (widget.meeting.isExpired)
                        const Text(
                          "Expired",
                          style: TextStyle(color: ColorPalette.red),
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
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    if (widget.meeting.ratedByClient &&
                        !widget.meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.green),
                          CustomText(text: "Rated by client")
                        ],
                      ),
                    if (!widget.meeting.ratedByClient &&
                        widget.meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.yellow),
                          CustomText(text: "Rated by you")
                        ],
                      ),
                    if (widget.meeting.ratedByClient &&
                        widget.meeting.ratedByTherapist)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorPalette.green),
                          SizedBox(width: 4),
                          CustomText(text: "Rated by both sides", size: 12,)
                        ],
                      ),
                    if (!widget.meeting.ratedByClient &&
                        !widget.meeting.ratedByTherapist &&
                        widget.meeting.isExpired)
                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (_) => RateConsultationDialog(selectedRating: index+1, meetingsController: meetingsController, meeting: widget.meeting),
                              );
                            },
                            child: Icon(Icons.star_border_rounded,
                                color: Colors.grey),
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
