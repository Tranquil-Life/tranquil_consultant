part of 'message_model.dart';

_$MessageModelFromJson(Map<String, dynamic> json) =>
    MessageModel(
        messageId: json['id'],
        chatId: json['chat_id'],
        senderId: json['sender_id'],
        senderType: json['sender_type'] ?? "",
        message: json['message'] ?? "",
        messageType: json['message_type'] ?? "",
        createdAt: DateTime.parse(json['created_at'])
    );
    
  _$MessageModelFromDoc(Map<String, dynamic> doc) =>
    MessageModel(
        messageId: doc['id'],
        chatId: doc['chat_id'],
        senderId: doc['sender_id'],
        senderType: doc['sender_type'] ?? "",
        message: doc['message'] ?? "",
        messageType: doc['message_type'] ?? "",
      createdAt: (doc['created_at'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
