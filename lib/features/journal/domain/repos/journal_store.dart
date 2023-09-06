import 'package:tl_consultant/features/journal/domain/entities/note.dart';

abstract class IJournalDataStore{
  set updateNoteColor(Note val);

  set updateJournal(List<Note> journal);
  List<Note> get getJournal;
}