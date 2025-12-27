import 'package:tl_consultant/core/data/store.dart';
import 'package:tl_consultant/features/profile/domain/repos/user_data_store.dart';

abstract class Keys {
  static const user = 'user';
  static const usingAvatar = 'usingAvatar';
  static const qualifications = 'qualifications';
  static const String lastLocationUpdateKey = 'last_location_update_ts';
}

UserDataStore userDataStore = UserDataStore();

class UserDataStore extends IUserDataStore {
  @override
  set isUsingAvatar(bool val) => getStore.set(Keys.usingAvatar, true);

  @override
  bool get isUsingAvatar => getStore.get(Keys.usingAvatar) ?? false;

  @override
  Map<String, dynamic> get user =>
      getStore.get(Keys.user) ?? <String, dynamic>{};

  @override
  set user(Map<String, dynamic> val) => getStore.set(Keys.user, val);

  @override
  List get qualifications =>
      getStore.get(Keys.qualifications) ?? [];

  @override
  set qualifications(List val) =>
      getStore.set(Keys.qualifications, val);
}
