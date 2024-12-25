

import 'package:tl_consultant/features/activity/domain/entities/notification.dart';
import 'package:tl_consultant/features/activity/domain/entities/notification_type.dart';

class NotificationModel extends NotificationData{
  NotificationModel({
    required super.id,
    required super.body,
    required super.type,
    required super.read,
    required super.createdAt
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

}

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'],
      body: json['body'],
      type: NotificationType(json['type']),
      read: json['read'] == 0 ? false : true,
      createdAt: DateTime.parse(json['created_at']) ,
    );