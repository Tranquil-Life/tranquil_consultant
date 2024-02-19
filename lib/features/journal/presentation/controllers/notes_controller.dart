import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/journal/data/repos/journal_repo.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tabs/personal_notes_tab.dart';
import 'package:tl_consultant/features/journal/presentation/screens/shared_note.dart';
import 'package:tl_consultant/features/journal/presentation/screens/tabs/shared_notes_tab.dart';

class NotesController extends GetxController with GetTickerProviderStateMixin {
  static NotesController instance = Get.find();

  late TabController tabController = TabController(length: 2, vsync: this);

  final journalRepo = JournalRepoImpl();
  var noteDeleted = false.obs;
  var defaultView = grid.obs;
  RxList<SharedNote> sharedNotesList = <SharedNote>[].obs;

  List<Widget> journalTabs = [const PersonalNotes(), SharedNotesTab()];
  var journalTabIndex = 0.obs;

  switchTab() async {
    switch (journalTabIndex.value) {
      case 0:
        journalTabIndex.value = tabController.index;
        if (sharedNotesList.isEmpty) {
          print("shared notes");
          //await loadfirstSharedNotes();
        }
        break;
      case 1:
        journalTabIndex.value = tabController.index;
        if (sharedNotesList.isEmpty) {
          print("personal notes");

          //await loadfirstPersonalNotes();
        }
        break;

      default:
        journalTabIndex.value = 0;
    }
  }

  //pagination vars
  var page = 1.obs;
  var limit = 10.obs;
  // There is next page or not
  var hasNextPage = true.obs;
  // Used to display loading indicators when _firstLoad function is running
  var isFirstLoadRunning = false.obs;
  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  var lastNoteId = 0.obs;
  // The controller for the ListView
  late ScrollController scrollController;

  Future loadfirstSharedNotes() async {
    isFirstLoadRunning.value = true;

    Either either =
        await journalRepo.getJournal(page: page.value, limit: limit.value);
    print(page);

    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      sharedNotesList.clear();

      var data = r['data'];
      for (int i = 0; i < (data as List).length; i++) {
        SharedNote note = SharedNote.fromJson(data[i]);
        sharedNotesList.add(note);
      }

      if (sharedNotesList.isNotEmpty) {
        lastNoteId.value = sharedNotesList[sharedNotesList.length - 1].id;
      } else {
        isFirstLoadRunning.value = false;
      }
    });

    update(); // Notify listeners that the notes list has changed
    isFirstLoadRunning.value = false;
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  loadMoreSharedNotes() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.position.extentAfter < 300) {
      isLoadMoreRunning.value =
          true; // Display a progress indicator at the bottom
      page.value += 1; // Increase _page by 1

      var result =
          await journalRepo.getJournal(page: page.value, limit: limit.value);

      if (result.isRight()) {
        List<SharedNote> fetchedNotes = [];

        result.map((r) => fetchedNotes =
            (r as List).map((e) => SharedNote.fromJson(e)).toList());
        if (fetchedNotes.isNotEmpty) {
          sharedNotesList.addAll(fetchedNotes);
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          hasNextPage.value = false;
        }

        isLoadMoreRunning.value = false;
      } else {
        result.leftMap((l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red));
      }

      update();
    }
  }

  clearData() {
    page.value = 1;
  }

  listenToTabController() {
    tabController.addListener(() {
      switchTab();
    });
  }

  @override
  void onInit() {
    listenToTabController();
    //loadfirstPersonalNotes();
    // loadfirstSharedNotes();
    super.onInit();
  }
}
