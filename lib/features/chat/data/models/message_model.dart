import 'package:cloud_firestore/cloud_firestore.dart';
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

 // Static method for JSON data
  static MessageModel fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  // Static method for Firestore document data
  static MessageModel fromDoc(Map<String, dynamic> doc) =>
      _$MessageModelFromDoc(doc);
}

