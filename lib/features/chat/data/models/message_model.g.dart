part of 'message_model.dart';

_$MessageModelFromJson(Map<String, dynamic> json) =>
    MessageModel(
        id: json['id'],
        from: json['from'],
        userType: json['user_type'],
        displayName: json['display_name'],
        meetingId: json['meeting_id'],
        message: json['message'] ?? "",
        read: json['read'] ?? [] ,
        parentId: json['parent_id'] ?? 0,
        parentMessage: json['parent_message'] ?? '',
        messageType: json['message_type'] ?? '',
        createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: null,
    );

_$MessageModelFromDoc(DocumentSnapshot<Map<String, dynamic>> doc){
    var map = doc.data()!;
    return MessageModel(
        id: map['id'],
        from: map['from'],
        userType: map['user_type'],
        meetingId: map['meeting_id'],
        message: map['message'] ?? "",
        read: map['read'] ?? [] ,
        parentId: map['parent_id'] ?? 0,
        parentMessage: map['parent_message'] ?? '',
        messageType: map['message_type'] ?? '',
        createdAt: (map["created_at"] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: null
    );
}