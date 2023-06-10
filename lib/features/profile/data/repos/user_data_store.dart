import 'package:tl_consultant/app/data/store.dart';
import 'package:tl_consultant/features/profile/domain/repos/user_data_store.dart';

abstract class _Keys {
  static const user = 'user';
  static const usingAvatar = 'usingAvatar';
}

UserDataStore userDataStore = UserDataStore();

class UserDataStore extends IUserDataStore {

  @override
  set isUsingAvatar(bool val) => getStore.set(_Keys.usingAvatar, true);
  @override
  bool get isUsingAvatar => getStore.get(_Keys.usingAvatar) ?? false;

  @override
  Map<String, dynamic> get user => getStore.get(_Keys.user) ?? <String, dynamic>{};
  @override
  set user(Map<String, dynamic> val) => getStore.set(_Keys.user, val);

  // @override
  // Map<String, dynamic>? get user => getStore.get(_Keys.user);
  // @override
  // set user(Map<String, dynamic>? val) => getStore.set(_Keys.user, val!);

}