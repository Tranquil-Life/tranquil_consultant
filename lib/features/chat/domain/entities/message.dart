part 'message.g.dart';

class Message {
  final int? messageId;
  final int? chatId;
  final int? senderId;
  final int? parentId;
  final String? senderType;
  final String? message;
  final String? messageType;
  final String? caption;
  final Message? quoteMessage;
  final List<Map<String, dynamic>>? read;
  final String? reaction;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  Message({
    this.messageId,
    this.chatId,
    this.senderId,
    this.parentId,
    this.senderType,
    this.message,
    this.messageType,
    this.caption,
    this.quoteMessage,
    this.read,
    this.reaction,
    this.createdAt,
    this.updatedAt
  });

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}