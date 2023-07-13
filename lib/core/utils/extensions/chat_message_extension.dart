import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

enum MessageType { text, image, video, audio }

extension ChatMessageExtension on Message {
  bool get fromYou => from == userDataStore.user['id'];

  bool get isSent => false;

  set isSent(bool isSent) {

  }

  MessageType get type {
    switch (messageType) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      default:
        return MessageType.text;
    }
  }

  String get timeSent => createdAt!.formattedTime;

  String? get data => message;
}