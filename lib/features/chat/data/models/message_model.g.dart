part of 'message_model.dart';

MessageModel messageModelFromJsonSafe(Map<String, dynamic> json) {
    DateTime? safeParseDate(dynamic v) {
        if (v == null) return null;
        if (v is DateTime) return v;
        if (v is int) {
            // if backend sends unix seconds/millis, adjust if needed
            // Here assume millis if it's large
            return DateTime.fromMillisecondsSinceEpoch(v > 1000000000000 ? v : v * 1000);
        }
        final s = v.toString();
        return DateTime.tryParse(s);
    }

    int? safeInt(dynamic v) {
        if (v == null) return null;
        if (v is int) return v;
        if (v is num) return v.toInt();
        return int.tryParse(v.toString());
    }

    return MessageModel(
        messageId: safeInt(json['id']),
        chatId: safeInt(json['chat_id']),
        senderId: safeInt(json['sender_id']),
        senderType: (json['sender_type'] ?? "").toString(),
        message: (json['message'] ?? "").toString(),
        messageType: (json['message_type'] ?? "").toString(),
        createdAt: safeParseDate(json['created_at']) ?? DateTime.now(), // ✅ fallback
        updatedAt: safeParseDate(json['updated_at']),
        caption: json['caption']?.toString(),
        reaction: json['reaction']?.toString(),
        read: (json['read'] as List?)
            ?.whereType<Map>()
            .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
            .toList()
            .cast<Map<String, dynamic>>(),
    );
}

//MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
//     MessageModel(
//         messageId: json['id'],
//         chatId: json['chat_id'],
//         senderId: json['sender_id'],
//         senderType: json['sender_type'] ?? "",
//         message: json['message'] ?? "",
//         messageType: json['message_type'] ?? "",
//         createdAt: DateTime.parse(json['created_at'])
//     );