abstract class IUserDataStore {
  Map<String, dynamic> get user;
  set user(Map<String, dynamic> val);
  bool get isUsingAvatar;
  set isUsingAvatar(bool val);
}