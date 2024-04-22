import 'package:tl_consultant/features/consultation/data/models/client_model.dart';

class PersonalNote {
  final int id;
  final int consultantId;
  final String heading;
  final String body;
  final bool isFavourite;
  final List attachments;
  final DateTime updatedAt;

  PersonalNote(
      {required this.id,
      required this.consultantId,
      required this.heading,
      required this.body,
      required this.isFavourite,
      required this.attachments,
      required this.updatedAt});

  Map<String, dynamic> toJson(PersonalNote instance) => <String, dynamic>{
        'id': instance.id,
        'heading': instance.heading,
        'body': instance.body,
        'isFavorite': instance.isFavourite,
        'attachments': instance.attachments
      };
}

// factory PersonalNote.fromJson(Map<String, dynamic> json) => PersonalNote(
//       id: json['id'],
//       consultantId: json['consultant_id'],
//       canViewUpdates: json['can_view_updates'],
//       createdAt: DateTime.parse(json['created_at'].toString()),
//       note: NoteModel.fromJson(json['note']),
//       client: ClientModel.fromJson(json['client']));
