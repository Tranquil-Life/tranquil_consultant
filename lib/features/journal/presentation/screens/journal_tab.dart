import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tabs/personal_notes_tab.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tabs/shared_notes_tab.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/tab_bar.dart';

class JournalTab extends StatelessWidget {
  JournalTab({Key? key}) : super(key: key);

  final notesController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "My Journal",
        centerTitle: false,
      ),
      body: UnFocusWidget(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CustomTabBar(
                  controller: notesController.tabController,
                  onTap: (i) {},
                  label1: "My notes",
                  label2: "Client notes",
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: displayHeight(context) * 0.5,
                  child: TabBarView(
                    controller: notesController.tabController,
                    children: [
                      PersonalNotesTab(),
                      SharedNotesTab(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "My Journal",
//         centerTitle: true,
//         hideBackButton: false,
//         actions: [
//           AppBarAction(
//             onPressed: () {},
//             child: const Icon(Icons.filter_list_alt),
//           ),
//         ],
//       ),
//       body: const UnFocusWidget(
//         child: Padding(
//           padding: EdgeInsets.all(12),
//           child: JournalBody(),
//         ),
//       ),
//     );
//   }
// }

// class NoteGrid extends StatelessWidget {
//   const NoteGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NotesController>(
//       builder: (_) => Expanded(
//         child: GridView.builder(
//           shrinkWrap: true,
//           controller: _.scrollController,
//           itemCount: _.journal.length,
//           itemBuilder: (context, index) => Container(
//             margin: const EdgeInsets.only(
//               left: 4,
//               right: 4,
//               bottom: 8,
//               top: 8,
//             ),
//             child: SelectableNoteWidget(
//               sharedNote: _.journal[index],
//               onTap: () async {
//                 await Get.to(
//                   NoteView(sharedNote: _.journal[index]),
//                 );
//               },
//             ),
//           ),
//           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: 200,
//             childAspectRatio: 1,
//             crossAxisSpacing: 14,
//             mainAxisSpacing: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SelectableNoteWidget extends StatelessWidget {
//   final SharedNote sharedNote;
//   final Function()? onTap;

//   const SelectableNoteWidget({super.key, required this.sharedNote, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topRight,
//       children: [
//         GestureDetector(
//           onTap: onTap!,
//           child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: displayWidth(context) * 0.3,
//               ),
//               child: NoteWidget(sharedNote: sharedNote)),
//         ),
//       ],
//     );
//   }
// }

// class JournalBody extends HookWidget {
//   const JournalBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tabController = useTabController(initialLength: 2);
//     final tabIndex = useState(0);
//     useEffect(() {
//       tabController.addListener(() {
//         tabIndex.value = tabController.index;
//       });
//       return () {
//         tabController.dispose();
//       };
//     }, [tabController]);
