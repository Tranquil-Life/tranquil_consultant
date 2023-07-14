part of 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options.dart';


class ViewParticipantsDialog extends StatefulWidget {
  const ViewParticipantsDialog({Key? key}) : super(key: key);

  @override
  State<ViewParticipantsDialog> createState() => _ViewParticipantsDialogState();
}

class _ViewParticipantsDialogState extends State<ViewParticipantsDialog> {
  late Animation<Offset> animation;

  @override
  void didChangeDependencies() {
    animation = ModalRoute.of(context)!.animation!.drive(
      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) =>
            SlideTransition(position: animation, child: child!),
        child: Container(
          margin: const EdgeInsets.only(top: 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: DashboardController.instance.participants.length,
                  itemBuilder: (context, index)=>
                      ParticipantTile(
                        participant: DashboardController.instance.participants[index],
                      ))
            ],
          ),
        ),
      ),
    );
  }
}


class ParticipantTile extends StatelessWidget {
  const ParticipantTile({super.key, required this.participant});


  final Participant participant;
  String get participantType {
    if (participant.userType == consultant) return 'You';
    if (participant.userType == client) return 'Client';
    return 'Participant';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(
            size: 44,
            imageUrl: participant.avatar,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(participant.displayName ?? "akks", style: const TextStyle(fontSize: 17)),
                Text(
                  participantType,
                  style: const TextStyle(
                    color: ColorPalette.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}