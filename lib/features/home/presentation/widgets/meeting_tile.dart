part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class MeetingTile extends StatefulWidget {
  final Meeting meeting;

  const MeetingTile({super.key, required this.meeting});

  @override
  State<MeetingTile> createState() => MeetingTileState();
}

class MeetingTileState extends State<MeetingTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: MeetingCard(
        meeting: widget.meeting,
      ),
    );
  }

}