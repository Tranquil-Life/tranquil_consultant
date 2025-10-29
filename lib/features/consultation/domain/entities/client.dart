import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ClientUser extends User {
  final int? id;
  final String displayName;

  ClientUser({
    this.id,
    super.avatarUrl = '',
    super.usesBitmoji,
    this.displayName = '',
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_name": displayName,
    "avatar_url": avatarUrl,
  };
}