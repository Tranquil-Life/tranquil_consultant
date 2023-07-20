import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';

part 'message_model.g.dart';

class MessageModel extends Message{
  MessageModel({
    required super.id,
    required super.from,
    required super.userType,
    required super.meetingId,
    required super.parentId,
    required super.parentMessage,
    required super.message,
    super.displayName,
    required super.read,
    required super.messageType,
    required super.createdAt,
    required super.updatedAt
  });

  factory MessageModel.fromDocumentSnapshot({required DocumentSnapshot<Map<String, dynamic>> doc}) => _$MessageModelFromDoc(doc);

  factory MessageModel.fromJson(Map<String, dynamic>  json) => _$MessageModelFromJson(json);
}
