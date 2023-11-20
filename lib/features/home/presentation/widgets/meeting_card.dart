part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';


class MeetingCard extends StatelessWidget {
  MeetingCard({Key? key, required this.meeting}) : super(key: key);
  final Meeting meeting;

  final now = DateTime.now();

  String lastName(){
    if(meeting.client.lastName.length >= 10){
      String newVal = "${meeting.client.lastName.substring(0, meeting.client.lastName.length-2)}...";
      return newVal;
    }else{
      return meeting.client.lastName;
    }
  }

  // Color? color(){
  //   if(meeting.status=="cancelled") {
  //     return Colors.blue.shade50;
  //   }else if(meeting.isExpired){
  //     return Colors.red.shade50;
  //   }else{
  //     Colors.grey[100];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                  color: ColorPalette.yellow,
                  borderRadius: BorderRadius.circular(28)
              ),
              child: Center(
                child: UserAvatar(
                  imageUrl: meeting.client.id < 2
                      ? "https://pbs.twimg.com/media/E4CvFPVWYAA-0vi.jpg"
                      : "https://media.istockphoto.com/id/1354524757/photo/casual-african-american-woman-smiling-in-purple-studio-isolated-background.jpg?b=1&s=170667a&w=0&k=20&c=8MxQbHDUExcyfLm9RvxITgGWMyfqCftOv5is8p426lE=",

                ),
              )
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MyDefaultTextStyle(
              style: const TextStyle(fontSize: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyDefaultTextStyle(
                      style: TextStyle(
                        color: ColorPalette.green[800],
                        fontSize: 16,
                      ),
                      child: topRow()
                  ),
                  buttonRow()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row buttonRow(){
    //DONE
    if(meeting.status == "ended"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text:
              '${meeting.duration} mins',
              children: const [
                TextSpan(
                  text: '-Done',
                  style: TextStyle(
                      color: ColorPalette.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),

                ),
              ],
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            textAlign: TextAlign.center,
          ),

          Text(
            meeting.startAt.folded, style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),),
        ],
      );
    }
    //CANCELLED STATE
    else if(meeting.status == "cancelled"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Cancelled',
              style: TextStyle(
                  color: ColorPalette.red,
                  decoration: TextDecoration.lineThrough
              )),
          Text(
            meeting.startAt.folded, style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),),
        ],
      );
    }
    //EXPIRED STATE
    else if(meeting.isExpired){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Expired",
              style:TextStyle(
                color: ColorPalette.red,
              )),
          Text(
              meeting.startAt.folded),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${meeting.duration} mins',
            style: meeting.isExpired ? const TextStyle(
                color: ColorPalette.red,
                decoration: TextDecoration.lineThrough
            ): null),
        Text(
            meeting.startAt.folded),
      ],
    );
  }

  Row topRow() {
    //DONE
    if(meeting.status == "ended"){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
                  meeting.client.displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600
                  )
              )),
          const SizedBox(width: 4),
          Text(meeting.startAt.formattedTime),
        ],
      );
    }
    //CANCELLED STATE
    else if(meeting.status == "cancelled"){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
                  meeting.client.displayName,
                  style: const TextStyle(
                      color: ColorPalette.red,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w600
                  )
              )),
          const SizedBox(width: 4),
          Text(meeting.startAt.formattedTime,
            style: TextStyle(
              color: ColorPalette.red,
              decoration: TextDecoration.lineThrough,
            ),),
        ],
      );
    }
    //EXPIRED STATE
    else if(meeting.isExpired){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
                  meeting.client.displayName,
                  style: const TextStyle(
                      color: ColorPalette.red,
                      fontWeight: FontWeight.w600
                  )
              )),
          const SizedBox(width: 4),
          Text(meeting.startAt.formattedTime,
              style: const TextStyle(
                  color: ColorPalette.red,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      );
    }
    //ONGOING
    else if(meeting.endAt.isAfter(now)
        && meeting.startAt.isBefore(now) || meeting.startAt == now)
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
                  meeting.client.displayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600
                  )
              )),
          const SizedBox(width: 4),
          Text(meeting.startAt.formattedTime),
        ],
      );
    }
    //DEFAULT STATE
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(
                meeting.client.displayName,
                style: const TextStyle(
                    fontWeight: FontWeight.w600
                )
            )),
        const SizedBox(width: 4),
        Text(meeting.startAt.formattedTime),
      ],
    );

  }
}