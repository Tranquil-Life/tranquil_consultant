import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/dialogs.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/rate_consultation_dialog.dart';
import 'package:tl_consultant/features/consultation/domain/entities/participant.dart';

part 'package:tl_consultant/features/chat/presentation/widgets/chat_more_options/end_session.dart';
part 'package:tl_consultant/features/chat/presentation/widgets/dialogs/view_participant_dialog.dart';

class MoreOptions extends StatelessWidget {
  const MoreOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        const PopupMenuItem(value: 0, child: Text('View participants')),
        const PopupMenuItem(value: 1, child: Text('Questionnaire')),
      ],
      onSelected: (int val) {
        switch (val) {
          case 0:
          showDialog(
            context: context,
            builder: (_) => const ViewParticipantsDialog(),
          );
            break;
          case 1:
            //TODO: View client's questionnaire result
            // final user = UserModel.fromJson(userDataStore.user);
            // if (questionnaireStore.hasAnsweredAll) {
            //   Get.toNamed(Routes.QUESTIONS_DETAILS);
            // } else {
            //   Get.toNamed(Routes.QUESTIONS_DETAILS)!
            //       .whenComplete(() => setStatusBarBrightness(true));
            // }
            break;
        }
      },
    );
  }
}