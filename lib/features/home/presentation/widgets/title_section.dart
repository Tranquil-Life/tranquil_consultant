part of 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';

class AppBar extends StatefulWidget {
  const AppBar({Key? key}) : super(key: key);

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  final onNotifyMsgRecognizer = TapGestureRecognizer();
  bool verified = false;

  @override
  void initState() {
    onNotifyMsgRecognizer.onTap = () {
      //TODO: Display Verification Email Sent Dialog
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            text: TextSpan(
              text: 'You need to ',
              style: const TextStyle(fontSize: 15.5, color: Colors.black),
              children: [
                TextSpan(
                  text: 'verify your account.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorPalette.red,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: onNotifyMsgRecognizer,
                ),
              ],
            ),
          ),
        ),

        const Spacer(),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (_) => [
            const PopupMenuItem(value: 0, child: Text('Our blog')),
          ],
          onSelected: (int val) {
            //TODO
            switch (val) {
              case 0:
                break;
            }
          },
        ),
      ],
    );
  }
}

class Title extends StatefulWidget {
  const Title({Key? key, this.user}) : super(key: key);

  final User? user;
  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {
  final activityController = ActivityController();
  var themeColor = ColorPalette.green;
  DateTime? meetingDate;
  User therapist = UserModel.fromJson(userDataStore.user);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Hi,',
                style: TextStyle(color: themeColor, fontSize: 22),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Questionnaire
                CustomIconButton(
                  onPressed: () {
                    Get.toNamed(Routes.EDIT_SLOTS);
                  },
                  icon: const Icon(
                    Icons.schedule,
                    size: 28,
                    color: ColorPalette.green,
                  ),
                ),

                const SizedBox(width: 12),

                //activity
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context)
                    //     .pushNamed(NotificationScreen.routeName);
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      CustomIconButton(
                        icon: Icon(
                          TranquilIcons.bell,
                          size: 28,
                          color: ColorPalette.green,
                        ),
                      ),
                      if (activityController.count() > 0)
                        CountIndicator(activityController.count()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        Obx(()=>
            Text(
              therapist.firstName,
              style: TextStyle(
                color: themeColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ))
      ],
    );
  }
}
