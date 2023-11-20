part of 'message.dart';

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  "id": instance.messageId,
  "chat_id": instance.chatId,
  "sender_id": instance.senderId,
  "sender_type": instance.senderType,
  "message": instance.message,
  "message_type": instance.messageType,
  "caption": instance.caption,
  "parent_id":instance.parentId,
  // "reply_message":instance.quoteMessage == null ? null : instance.quoteMessage!.toJson(),
  "read": instance.read,
  "reaction": instance.reaction,
  "created_at": instance.createdAt,
  //"updated_at": "2023-11-13T22:55:43.000000Z"
};