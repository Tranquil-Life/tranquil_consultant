import 'package:tl_consultant/features/journal/domain/entities/note.dart';

part 'note.g.dart';

class NoteModel extends Note {
  NoteModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.hexColor,
      required super.clientDp,
      required super.clientName,
      super.mood,
      required super.dateUpdated});

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}
