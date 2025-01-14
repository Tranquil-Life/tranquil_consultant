import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/journal/data/models/personal_note.dart';
import 'package:tl_consultant/features/journal/data/repos/journal_repo.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/shared_note.dart';

class NotesController extends GetxController with GetTickerProviderStateMixin {
  static NotesController instance = Get.find();

  late TabController tabController = TabController(length: 2, vsync: this);

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  var isBold = false.obs;
  var isItalic = false.obs;

  final journalRepo = JournalRepoImpl();
  var noteDeleted = false.obs;
  var layout = grid.obs;
  RxList<SharedNote> sharedNotesList = <SharedNote>[].obs;
  RxList<PersonalNote> personalNotesList = <PersonalNote>[].obs;

  //pagination vars
  var page = 1.obs;
  var limit = 10.obs;
  // There is next page or not
  var hasNextPage = true.obs;
  // Used to display loading indicators when _firstLoad function is running
  var isFirstPersonalNotesLoading = false.obs;
  // Used to display loading indicators when _loadMore function is running
  var isMorePersonalNotesLoading = false.obs;
  var isFirstSharedNotesLoading = false.obs;
  var isMoreSharedNotesLoading = false.obs;
  var lastNoteId = 0.obs;
  // The controller for the ListView
  late ScrollController scrollController;

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
        if (personalNotesList.isEmpty) {
          print("personal notes");
          await loadFirstPersonalNotes();
        }
        break;

      default:
        journalTabIndex.value = 0;
    }
  }

  Future loadFirstPersonalNotes() async {
    isFirstPersonalNotesLoading.value = true;

    Either either = await journalRepo.getPersonalNotes(
        page: page.value, limit: limit.value);
    either.fold((l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red),
            (r) {
      personalNotesList.clear();

      var data = r['data'];

      for (int i = 0; i < (data as List).length; i++) {
        PersonalNote note = PersonalNoteModel.fromJson(data[i]);
        personalNotesList.add(note);
      }

      if (personalNotesList.isNotEmpty) {
        lastNoteId.value = personalNotesList[personalNotesList.length - 1].id!;
      } else {
        isFirstPersonalNotesLoading.value = false;
      }

      update(); // Notify listeners that the notes list has changed
      isFirstPersonalNotesLoading.value = false;
    });
  }

  Future loadMorePersonalNotes() async {
    if (hasNextPage.value == true &&
        isFirstPersonalNotesLoading.value == false &&
        isMorePersonalNotesLoading.value == false &&
        scrollController.position.extentAfter < 300) {
      isMorePersonalNotesLoading.value =
          true; // Display a progress indicator at the bottom
      page.value += 1; // Increase _page by 1

      var result = await journalRepo.getPersonalNotes(
          page: page.value, limit: limit.value);

      if (result.isRight()) {
        List<PersonalNote> fetchedNotes = [];

        result.map((r) {
          final data = (r as Map<String, dynamic>)['data'];
          if (data is List) {
            fetchedNotes = data.map((e) => PersonalNoteModel.fromJson(e)).toList();
          } else {
            fetchedNotes = [];
          }

          if (fetchedNotes.isNotEmpty) {
            personalNotesList.addAll(fetchedNotes);
          } else {
            // No more data; stop further GET requests
            hasNextPage.value = false;
          }
        });


        isMorePersonalNotesLoading.value = false;
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

  Future loadFirstSharedNotes() async {
    isFirstSharedNotesLoading.value = true;

    Either either =
        await journalRepo.getSharedNotes(page: page.value, limit: limit.value);

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
        isFirstSharedNotesLoading.value = false;
      }
    });

    update(); // Notify listeners that the notes list has changed
    isFirstSharedNotesLoading.value = false;
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  Future loadMoreSharedNotes() async {
    if (hasNextPage.value == true &&
        isFirstSharedNotesLoading.value == false &&
        isMoreSharedNotesLoading.value == false &&
        scrollController.position.extentAfter < 300) {
      isMoreSharedNotesLoading.value =
          true; // Display a progress indicator at the bottom
      page.value += 1; // Increase _page by 1

      var result = await journalRepo.getSharedNotes(
          page: page.value, limit: limit.value);

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

        isMoreSharedNotesLoading.value = false;
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

  Future createNote({List? attachments}) async {
    PersonalNote note =
        PersonalNote(heading: titleController.text, body: bodyController.text);
    Either either = await journalRepo.addNote(note: note);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      var data = r as Map<String, dynamic>;

      personalNotesList.insert(0, PersonalNoteModel.fromJson(data['data']));

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Success",
          message: "Added new note",
          backgroundColor: ColorPalette.green);
    });

    update();
  }

  listenToTabController() {
    tabController.addListener(() {
      switchTab();
    });
  }

  @override
  void onInit() {
    listenToTabController();
    super.onInit();
  }

  clearData() {
    page.value = 1;
    titleController.clear();
    bodyController.clear();
    isBold.value = false;
    isItalic.value = false;

    noteDeleted.value = false;
    layout.value = grid;
    sharedNotesList.clear();
    personalNotesList.clear();
  }
}
