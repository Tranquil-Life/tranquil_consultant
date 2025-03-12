import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:tl_consultant/core/domain/store.dart';

abstract class _Keys {
  static const isOnboardingCompleted = 'isOnboardingCompleted';
  static const isSignedIn = 'isSignedIn';
  static const hasShownChatDisableDialog = 'hasShownChatDisableDialog';
  static const hasReadMeetingAbsenceMessage = 'hasReadMeetingAbsenceMessage';
}

GetStore getStore = GetStore();

class GetStore extends IStore {
  GetStorage getStorage = GetStorage();

  @override
  get (String key) => getStorage.read(key);

  @override
  set(String key, dynamic val) =>getStorage.write(key, val);

  @override
  Future<void> clearAllData() => getStorage.erase();
}