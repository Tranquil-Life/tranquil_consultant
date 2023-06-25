import 'package:tl_consultant/app/data/store.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';
import 'package:tl_consultant/features/journal/domain/repos/journal_store.dart';

abstract class _Keys {
  static const journal = 'journal';
}

JournalStore journalStore = JournalStore();

class JournalStore extends IJournalDataStore{

  @override
  set updateJournal(List<Note> journal)=> getStore.set(_Keys.journal, journal);

  @override
  set updateNoteColor(Note val) {
    getJournal.firstWhere((element)
    => element.id == val.id).hexColor = val.hexColor;
  }

  @override
  List<Note> get getJournal => getStore.get(_Keys.journal) ?? <Note>[];

}