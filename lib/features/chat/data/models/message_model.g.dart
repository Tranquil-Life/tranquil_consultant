part of 'message_model.dart';

_$ReplyMessageModelFromJson(Map<String, dynamic> json) =>
    MessageModel(
        messageId: json['id'],
        chatId: json['chat_id'],
        senderId: json['sender_id'],
        senderType: json['sender_type'] ?? "",
        message: json['message'] ?? "",
        messageType: json['message_type'] ?? "",
        createdAt: DateTime.parse(json['created_at'])
    );