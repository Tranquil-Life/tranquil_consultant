import 'package:equatable/equatable.dart';

part 'message.g.dart';

class Message {
  int? id;

  int? from;
  String? userType;
  int? meetingId;
  String? message;
  List? read;
  String? messageType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String reaction;
  String caption;
  int? parentId;
  String parentMessage;
  String? displayName;

  Message({
    this.id,
    this.from,
    this.userType,
    this.meetingId,
    this.message,
    this.read,
    this.messageType,
    this.createdAt,
    this.updatedAt,
    this.reaction='',
    this.caption='',
    this.parentId,
    this.parentMessage = '',
    this.displayName
  });


  Map<String, dynamic> toJson() => _$MessageToJson(this);
}