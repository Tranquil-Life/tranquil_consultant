import 'package:tl_consultant/features/consultation/data/models/client_model.dart';
import 'package:tl_consultant/features/journal/data/models/note.dart';

class PersonalNote {
  final int id;
  final int consultantId;
  final bool canViewUpdates;
  final DateTime createdAt;
  final NoteModel note;
  final ClientModel client;

  PersonalNote(
      {required this.id,
      required this.consultantId,
      required this.canViewUpdates,
      required this.createdAt,
      required this.note,
      required this.client});

  factory PersonalNote.fromJson(Map<String, dynamic> json) => PersonalNote(
      id: json['id'],
      consultantId: json['consultant_id'],
      canViewUpdates: json['can_view_updates'],
      createdAt: DateTime.parse(json['created_at'].toString()),
      note: NoteModel.fromJson(json['note']),
      client: ClientModel.fromJson(json['client']));
}
