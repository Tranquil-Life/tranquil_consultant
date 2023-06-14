import 'package:tl_consultant/features/activity/domain/entities/notification_type.dart';

abstract class NotificationData {
  final int? id;
  final String? senderDp;
  final String? heading;
  final String? body;
  final NotificationType type;
  final DateTime? createdAt;

  const NotificationData({
    this.id,
    this.senderDp,
    this.heading,
    this.body,
    this.type = NotificationType.notification,
    this.createdAt});
}