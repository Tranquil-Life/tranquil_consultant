part of 'note.dart';

_$NoteModelFromJson(Map<String, dynamic> json) =>
    NoteModel(
        id: json['id'],
        title: json['heading'] ?? "",
        description: json['body'] ?? "",
        clientDp: json['client_dp'] ?? "",
        clientName: json['client_name'] ?? "",
        mood: json['mood'] ?? "",
        hexColor: json['hex_color'] ?? "0xFFFDFDFD",
        dateUpdated: DateTime.parse(json['updated_at'].toString())
    );