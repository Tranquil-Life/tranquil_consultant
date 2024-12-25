import 'package:tl_consultant/features/activity/domain/entities/notification_type.dart';

abstract class NotificationData {
  final int? id;
  final String? senderDp;
  final String? body;
  final bool? read;
  final NotificationType type;
  final DateTime? createdAt;

  const NotificationData(
      {this.id,
        this.senderDp,
        this.body,
        this.read,
        this.type = NotificationType.notification,
        this.createdAt});
}
