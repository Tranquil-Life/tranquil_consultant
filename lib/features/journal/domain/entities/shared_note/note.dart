import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: true)
class Note {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'heading')
  String title;
  @JsonKey(name: 'body')
  String description;
  String? mood;
  String hexColor;
  DateTime? dateUpdated;

  Note(
      {this.id,
      this.title = '',
      this.description = '',
      this.mood,
      required this.hexColor,
      this.dateUpdated});

  factory Note.fromJson(Map<String, dynamic> json) =>
    Note(
      id: json['id'],
      title: json['heading'] ?? "",
      description: json['body'] ?? "",
      mood: json['mood'] ?? "",
      hexColor: json['hex_color'] ?? "0xFFFDFDFD",
      dateUpdated: DateTime.parse(json['updated_at'].toString())
    );    
}
