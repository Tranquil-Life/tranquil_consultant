import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';

import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tabs/personal_notes_tab.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tabs/shared_notes_tab.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/tab_bar.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key});

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  final notesController = Get.put(NotesController());

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      notesController.loadFirstPersonalNotes();
      notesController.loadFirstSharedNotes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // GestureDetector(
                      //     onTap: () {
                      //       //...
                      //     },
                      //     child: Wrap(
                      //       direction: Axis.horizontal,
                      //       crossAxisAlignment: WrapCrossAlignment.center,
                      //       children: [Icon(Icons.filter_list), Text("Filters")],
                      //     ),
                      //     ),
                      GestureDetector(
                        onTap: () {},
                        child: Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Icon(Icons.keyboard_arrow_down_outlined),
                            // Text(
                            //   "Sort by",
                            // ),
                            // SizedBox(
                            //   width: 24,
                            // ),
                            Obx(()=>GestureDetector(
                              child: SvgPicture.asset(
                                  'assets/images/icons/${notesController.defaultView.value != grid ? 'grid_icon' : 'list_icon'}.svg',
                                  height: 30,
                                  width: 30),
                              onTap: () {
                                if (notesController.defaultView.value == grid) {
                                  notesController.defaultView.value = list;
                                } else {
                                  notesController.defaultView.value = grid;
                                }
                              },
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: TabBarView(
                    controller: notesController.tabController,
                    children: [
                      const PersonalNotesTab(),
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
