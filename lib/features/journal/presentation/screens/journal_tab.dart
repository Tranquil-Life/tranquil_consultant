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

  // late TabController controller = TabController(length: 2, vsync: this);

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
