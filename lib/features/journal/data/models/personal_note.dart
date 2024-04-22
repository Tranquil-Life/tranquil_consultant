import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';

class PersonalNoteModel extends PersonalNote {
  PersonalNoteModel(
      {required super.id,
      required super.consultantId,
      required super.heading,
      required super.body,
      required super.isFavourite,
      required super.attachments,
      required super.updatedAt});

  factory PersonalNoteModel.fromJson(Map<String, dynamic> json) =>
      PersonalNoteModel(
          id: json['id'],
          consultantId: json['consultant_id'],
          heading: json['heading'],
          body: json['body'],
          isFavourite: json['isFavorite'] == 0 || json['isFavorite'] == false ? false : true,
          attachments: json['attachments'] ?? [],
          updatedAt: DateTime.parse(json['updated_at'].toString()));
}
