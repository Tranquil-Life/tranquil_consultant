import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ClientUser extends User {
  final int id;
  final String displayName;

  ClientUser({
    required this.id,
    super.avatarUrl = '',
    this.displayName = '',
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_name": displayName,
    "avatar_url": avatarUrl,
  };
}