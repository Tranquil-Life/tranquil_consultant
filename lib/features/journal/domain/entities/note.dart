import 'package:json_annotation/json_annotation.dart';
part 'note.g.dart';

@JsonSerializable(createToJson: true)
class Note {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'heading')
  String title;
  @JsonKey(name: 'body')
  String description;
  String clientName;
  String clientDp;
  String? mood;
  String hexColor;
  DateTime? dateUpdated;

  Note(
      {this.id,
      this.title = '',
      this.description = '',
      this.clientName = '',
      this.clientDp = '',
      this.mood,
      required this.hexColor,
      this.dateUpdated});
}
