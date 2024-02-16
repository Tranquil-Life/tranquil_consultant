// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// import 'package:get/get.dart';
// import 'package:tl_consultant/app/presentation/theme/colors.dart';
// import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
// import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
// import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
// import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
// import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

// import 'package:tl_consultant/features/journal/presentation/screens/tabs/personal_notes_tab.dart';
// import 'package:tl_consultant/features/journal/presentation/screens/tabs/shared_notes_tab.dart';
// import 'package:tl_consultant/features/journal/presentation/screens/selected_note_view.dart';
// import 'package:tl_consultant/features/journal/presentation/widgets/note_widget.dart';

// class JournalTab extends StatelessWidget {
//   const JournalTab({Key? key}) : super(key: key);

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
//       body: UnFocusWidget(
//         child: Padding(
//           padding: EdgeInsets.all(12),
//           child: JournalBody(),
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
//   JournalBody({super.key});

//   NotesController notesController = Get.put(NotesController());

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

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(),
//             // TabBar(
//             //   controller: tabController,
//             //   onTap: (v) {
//             //     tabIndex.value = v;
//             //   },
//             //   splashFactory: NoSplash.splashFactory,
//             //   overlayColor: MaterialStateProperty.resolveWith<Color?>(
//             //     (Set<MaterialState> states) {
//             //       return states.contains(MaterialState.focused)
//             //           ? null
//             //           : Colors.transparent;
//             //     },
//             //   ),
//             //   dividerHeight: 2,
//             //   dividerColor: ColorPalette.green,
//             //   indicatorColor: Colors.transparent,
//             //   tabs: [
//             //     Container(
//             //       height: 40,
//             //       width: double.maxFinite,
//             //       decoration: BoxDecoration(
//             //         borderRadius: const BorderRadius.only(
//             //           topLeft: Radius.circular(6),
//             //           topRight: Radius.circular(6),
//             //         ),
//             //         color: tabIndex.value == 0
//             //             ? ColorPalette.green
//             //             : Colors.transparent,
//             //       ),
//             //       child: Center(
//             //         child: Text(
//             //           "My notes",
//             //           style: TextStyle(
//             //             color:
//             //                 tabIndex.value == 0 ? Colors.white : Colors.black,
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //     Container(
//             //       height: 40,
//             //       width: double.maxFinite,
//             //       decoration: BoxDecoration(
//             //         borderRadius: const BorderRadius.only(
//             //           topLeft: Radius.circular(6),
//             //           topRight: Radius.circular(6),
//             //         ),
//             //         color: tabIndex.value == 1
//             //             ? ColorPalette.green
//             //             : Colors.transparent,
//             //       ),
//             //       child: Center(
//             //         child: GestureDetector(
//             //           child: Text(
//             //             "Client notes",
//             //             style: TextStyle(
//             //               color:
//             //                   tabIndex.value == 1 ? Colors.white : Colors.black,
//             //             ),
//             //           ),
//             //           onTap: () {},
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             // const SizedBox(height: 10),
//             // Expanded(
//             //   child: TabBarView(
//             //     controller: tabController,
//             //     children: notesController.journalTabs,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // class JournalBody extends StatefulWidget {
// //   const JournalBody({super.key});

// //   @override
// //   State<JournalBody> createState() => _JournalBodyState();
// // }

// // class _JournalBodyState extends State<JournalBody>
// //     with TickerProviderStateMixin {
// //   late TabController? controller = TabController(length: 2, vsync: this);

// //   final searchBarController = TextEditingController();
// //   int index = 0;
// //   litenToController() {
// //     controller!.addListener(
// //       () {
// //         setState(() {
// //           index = controller!.index;
// //         });
// //       },
// //     );
// //   }

// //   final NotesController _ = Get.put(NotesController());

// //   @override
// //   void initState() {
// //     _.loadfirstNotes();
// //     _.scrollController = ScrollController()
// //       ..addListener(() => _.loadMoreNotes());

// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(() => Column(
// //           children: [
// //             CustomTabbar(
// //                 controller: controller,
// //                 whathappensontap: (int tabindex) {
// //                   setState(() {
// //                     HapticFeedback.lightImpact();
// //                     index = tabindex;
// //                   });
// //                 },
// //                 tabviewlabel1: "My notes",
// //                 tabviewlabel2: "Client notes"),
// //             // const SearchBar(),
// //             const SizedBox(height: 20),
// //             Row(
// //               children: [
// //                 IconButton(
// //                   onPressed: () {},
// //                   icon: const Icon(
// //                     Icons.filter_1,
// //                   ),
// //                 ),
// //                 const Text("Filter"),
// //               ],
// //             ),
// //             Expanded(
// //               child: TabBarView(controller: controller, children: const [
// //                 ConsultantNote(),
// //                 ClientNote(),
// //               ]),
// //             ),

// //             if (_.isLoadMoreRunning.value == true)
// //               const Padding(
// //                 padding: EdgeInsets.only(top: 10, bottom: 40),
// //                 child: Center(
// //                   child: CircularProgressIndicator(color: ColorPalette.green),
// //                 ),
// //               ),
// //           ],
// //         ));
// //   }
// // }