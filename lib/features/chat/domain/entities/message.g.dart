part of 'message.dart';

Map<String, dynamic> _$NoteToJson(Message instance) => <String, dynamic>{
  'meeting_id':instance.meetingId,
  'message':instance.message,
  'message_type':instance.messageType,
  'caption':instance.caption,
  'parent_id':instance.parentId,
};