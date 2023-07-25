import 'package:tl_consultant/features/chat/domain/entities/message.dart';

part 'message_model.g.dart';

class MessageModel extends Message{
  MessageModel({
    required super.messageId,
    required super.userId,
    super.userType,
    super.meetingId,
    super.replyMessage,
    required super.message,
    super.username,
    super.seen,
    required super.messageType,
    required super.createdAt,
    super.caption,
    super.updatedAt
  });

  factory MessageModel.fromJson(Map<String, dynamic>  json) => _$ReplyMessageModelFromJson(json);
}

