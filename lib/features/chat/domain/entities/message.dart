import 'package:equatable/equatable.dart';

part 'message.g.dart';

class Message {
  int? meetingId;
  int? messageId;
  String? message;
  String? messageType;
  Message? replyMessage;
  String? username;
  String? caption;
  int? userId;
  String? userType;
  List<int>? seen;
  DateTime? createdAt;
  DateTime? updatedAt;


  Message({
    this.meetingId,
    this.messageId,
    this.message,
    this.messageType,
    this.replyMessage,
    this.username,
    this.caption,
    this.userId,
    this.userType,
    this.seen,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}