import 'package:tl_consultant/features/chat/domain/entities/message.dart';

part 'message_model.g.dart';

class MessageModel extends Message{
  MessageModel({
    required super.messageId,
    required super.senderId,
    required super.senderType,
    required super.chatId,
    super.quoteMessage,
    required super.message,
    required super.messageType,
    super.read,
    super.reaction,
    super.caption,
    required super.createdAt,
    super.updatedAt
  });

  factory MessageModel.fromJson(Map<String, dynamic>  json) => _$ReplyMessageModelFromJson(json);
}

