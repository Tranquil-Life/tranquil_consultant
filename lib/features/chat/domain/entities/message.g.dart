part of 'message.dart';

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  "id": instance.messageId,
  "from":instance.userId,
  'meeting_id':instance.meetingId,
  "user_type": instance.userType,
  "display_name": instance.username,
  'message':instance.message,
  'message_type':instance.messageType,
  'caption':instance.caption,
  'reply_message':instance.replyMessage == null ? null : instance.replyMessage!.toJson(),
  "created_at": instance.createdAt!,
  // 'updated_at': instance.updatedAt
};