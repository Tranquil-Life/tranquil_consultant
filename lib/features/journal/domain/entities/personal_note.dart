import 'package:tl_consultant/features/consultation/data/models/client_model.dart';

class PersonalNote {
  int? id;
  int? consultantId;
  String heading;
  String body;
  bool? isFavourite;
  List? attachments;
  DateTime? updatedAt;

  PersonalNote(
      {this.id,
      this.consultantId,
      required this.heading,
      required this.body,
      this.isFavourite,
      this.attachments,
      this.updatedAt});

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
