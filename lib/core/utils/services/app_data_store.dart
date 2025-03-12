import 'package:tl_consultant/core/data/store.dart';

abstract class _Keys {
  static const isOnboardingCompleted = 'isOnboardingCompleted';
  static const isSignedIn = 'isSignedIn';
  static const hasShownChatDisableDialog = 'hasShownChatDisableDialog';
  static const hasReadMeetingAbsenceMessage = 'hasReadMeetingAbsenceMessage';
}

class AppData {
  static bool get isSignedIn =>getStore.get(_Keys.isSignedIn) ?? false;

  static set isSignedIn(bool val) =>getStore.set(_Keys.isSignedIn, val);

  static bool get hasShownChatDisableDialog => getStore.get(_Keys.hasShownChatDisableDialog) ?? false;

  static set hasShownChatDisableDialog(bool val) => getStore.set(_Keys.hasShownChatDisableDialog, val);
}