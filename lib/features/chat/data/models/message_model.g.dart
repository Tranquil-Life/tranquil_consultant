part of 'message_model.dart';

_$MessageModelFromJson(Map<String, dynamic> json) =>
    MessageModel(
        id: json['id'],
        from: json['from'],
        userType: json['user_type'],
        meetingId: json['meeting_id'],
        message: json['message'] ?? "",
        read: json['read'] ?? [] ,
        parentId: json['parent_id'] ?? 0,
        parentMessage: json['parent_message'] ?? '',
        messageType: json['message_type'] ?? '',
        createdAt: DateTime.parse(json['created_at'].toString()),
        updatedAt: DateTime.parse(json['updated_at'].toString())
    );