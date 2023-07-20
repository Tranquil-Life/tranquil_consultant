part of 'message.dart';

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  "id": instance.id,
  "from":instance.from,
  'meeting_id':instance.meetingId,
  "user_type": instance.userType,
  'message':instance.message,
  'message_type':instance.messageType,
  'caption':instance.caption,
  'parent_id':instance.parentId,
  'parent_message':instance.parentMessage,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt
};