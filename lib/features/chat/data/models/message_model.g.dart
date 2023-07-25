part of 'message_model.dart';

_$ReplyMessageModelFromJson(Map<String, dynamic> json) =>
    MessageModel(
      messageId: json['id'] ?? 0,
      userId: json['from'] ?? 0,
      userType: json['user_type'] ?? "",
      username: json['display_name']?? "",
      meetingId: json['meeting_id']?? 0,
      message: json['message'] ?? "",
      seen: json['seen'] ?? [] ,
      messageType: json['message_type'] ?? '',
      replyMessage: json['reply_message'] == null ? null : MessageModel.fromJson(json['reply_message']),
      createdAt: json['created_at'],
      updatedAt: null,
    );