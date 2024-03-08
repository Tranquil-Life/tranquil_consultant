// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
// import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
// import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
// import 'package:tl_consultant/features/journal/presentation/screens/selected_note_view.dart';
// import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

// class ConsultantNote extends StatelessWidget {
//   const ConsultantNote({super.key});

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

