import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/widgets/dialogs.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options/end_session_bottomsheet.dart';

part 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options/end_session.dart';

class MoreOptions extends StatelessWidget {
  const MoreOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        const PopupMenuItem(value: 0, child: Text('Invite participant')),
        const PopupMenuItem(value: 1, child: Text('View participants')),
        const PopupMenuItem(value: 2, child: Text('Questionnaire')),
        const PopupMenuItem(value: 3, child: Text('End session')),
      ],
      onSelected: (int val) {
        switch (val) {
          case 0:
          // showDialog(
          //   context: context,
          //   builder: (_) => const _SendInviteDialog(),
          // );
            break;
          case 1:
          // showDialog(
          //   context: context,
          //   builder: (_) => const _ViewParticipantsDialog(),
          // );
            break;
          case 2:
            //TODO: View client's questionnaire result
            // final user = UserModel.fromJson(userDataStore.user);
            // if (questionnaireStore.hasAnsweredAll) {
            //   Get.toNamed(Routes.QUESTIONS_DETAILS);
            // } else {
            //   Get.toNamed(Routes.QUESTIONS_DETAILS)!
            //       .whenComplete(() => setStatusBarBrightness(true));
            // }
            break;
          case 3:
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => const EndSessionBottomSheet(),
            );
            break;
        }
      },
    );
  }
}