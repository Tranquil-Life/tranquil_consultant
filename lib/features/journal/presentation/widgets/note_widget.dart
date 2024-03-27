// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:tl_consultant/app/presentation/theme/colors.dart';
// import 'package:tl_consultant/app/presentation/theme/fonts.dart';
// import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
// import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
// import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';

// class NoteWidget extends StatelessWidget {
//   const NoteWidget({Key? key, required this.sharedNote}) : super(key: key);
//   final SharedNote sharedNote;
//   static const _defaultNoteColor = Color(0xFFFDFDFD);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xffACD5E8),
//         // color: Color(int.parse(sharedNote.note.hexColor!)) ?? _defaultNoteColor,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Card(
//         elevation: 2,
//         margin: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.more_vert,
//                   color: Color.fromARGB(255, 76, 48, 81),
//                 ),
//                 const SizedBox(height: 4)
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: Platform.isIOS ? -8 : -4,
//             right: -4,
//             child: Container(
//               height: 50,
//               width: 50,
//               decoration: BoxDecoration(
//                 color: _defaultNoteColor,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const Text("data"),
//             const SizedBox(height: 10),
//             const Text(
//               "",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 76, 48, 81),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
