import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/journal/data/models/note.dart';
import 'package:tl_consultant/features/journal/data/repos/journal_repo.dart';
import 'package:tl_consultant/features/journal/data/repos/journal_store.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note.dart';

class NotesController extends GetxController {
  static NotesController instance = Get.find();

  final journalRepo = JournalRepoImpl();
  var noteDeleted = false.obs;

  RxList<SharedNote> journal = <SharedNote>[].obs;

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

  loadfirstNotes() async {
    isFirstLoadRunning.value = true;

    Either either =
        await journalRepo.getJournal(page: page.value, limit: limit.value);

    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      journal.clear();

      var data = r['data'];
      for (int i = 0; i < (data as List).length; i++) {
        SharedNote note = SharedNote.fromJson(data[i]);
        journal.add(note);
      }

      if (journal.isNotEmpty) {
        lastNoteId.value = journal[journal.length - 1].id;
      } else {
        isFirstLoadRunning.value = false;
      }
    });

    update(); // Notify listeners that the notes list has changed
    isFirstLoadRunning.value = false;
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  loadMoreNotes() async {
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
          journal.addAll(fetchedNotes);
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
}
