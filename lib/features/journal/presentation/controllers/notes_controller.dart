import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/journal/data/models/note.dart';
import 'package:tl_consultant/features/journal/data/repos/journal_repo.dart';
import 'package:tl_consultant/features/journal/data/repos/journal_store.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';

class NotesController extends GetxController{
  static NotesController instance = Get.find();
  final journalRepo = JournalRepoImpl();
  var currPageIndex = 0.obs;
  var noteDeleted = false.obs;

  final titleTEC = TextEditingController();
  final bodyTEC = TextEditingController();

  var noNotes = false.obs;

  Future<List<Note>> getJournal()
  async{

    if(NetworkController.instance.connectionStatus.value == 0){
      update();

      noNotes.value = journalStore.getJournal.isEmpty ? true : false;

      return journalStore.getJournal;
    }else{
      try{
        await Future.delayed(Duration(seconds: 1));
        var result = await journalRepo.getJournal();

        if(result.isRight()){
          List<Note> notes = result.getOrElse(() => NoteModel.fromJson({}));
          List<Note> arr = [];
          if(notes.length >= 10){
            for(int i=0; i < 10; i++){
              arr.add(notes[i]);
            }
            journalStore.updateJournal = arr;
            noNotes.value = journalStore.getJournal.isEmpty ? true : false;

          }else{
            journalStore.updateJournal = notes;
            noNotes.value = journalStore.getJournal.isEmpty ? true : false;
          }
          update();

          return notes;
        }
        else{
          result.leftMap((l)
          => CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red)
          );


          return <Note>[];
        }
      }catch(e){
        return <Note>[];
      }
    }
  }

  clearData(){
    currPageIndex.value = 0;

  }


}