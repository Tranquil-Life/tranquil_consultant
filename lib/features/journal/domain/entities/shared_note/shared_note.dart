import 'package:tl_consultant/features/consultation/data/models/client_model.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/note.dart';

class SharedNote {
  final int id;
  final int consultantId;
  final bool canViewUpdates;
  final DateTime createdAt;
  final Note? note;
  final ClientModel? client;

  SharedNote(
      {required this.id,
      required this.consultantId,
      required this.canViewUpdates,
      required this.createdAt,
      required this.note,
      required this.client});

  factory SharedNote.fromJson(Map<String, dynamic> json) => SharedNote(
      id: json['id'],
      consultantId: json['consultant_id'],
      canViewUpdates: json['can_view_updates'],
      createdAt: DateTime.parse(json['created_at'].toString()),
      note: json['note'] != null ? Note.fromJson(json['note']) : null,
      client: json['client'] != null ? ClientModel.fromJson(json['client']) : null
      );
}
