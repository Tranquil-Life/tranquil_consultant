part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const INTRODUCE_YOURSELF = _Paths.INTRODUCE_YOURSELF;
  static const PROFILE_PREVIEW = _Paths.PROFILE_PREVIEW;
  static const SIGN_UP_0 = _Paths.SIGN_UP_0 ;
  static const SIGN_UP_1 = _Paths.SIGN_UP_1 ;
  static const SIGN_UP_2 = _Paths.SIGN_UP_2 ;
  static const HOME_SCREEN = _Paths.HOME_SCREEN ;
  static const DASHBOARD = _Paths.DASHBOARD ;
  static const EDIT_SLOTS =_Paths.EDIT_SLOTS ;
  static const QUESTIONNAIRE = _Paths.QUESTIONNAIRE ;
  static const CHAT_SCREEN = _Paths.CHAT_SCREEN ;
  static const WALLET = _Paths.WALLET;
  static const NOTES_SCREEN = _Paths.NOTES_SCREEN ;
  static const PROFILE = _Paths.PROFILE ;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE ;
  static const SETTINGS = _Paths.SETTINGS ;
  static const VERIFY_RESET_ACCOUNT = _Paths.VERIFY_RESET_ACCOUNT ;
  static const UPDATE_PASSWORD = _Paths.UPDATE_PASSWORD ;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD ;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH_SCREEN = '/splash';
  static const ONBOARDING = '/onboarding';
  static const SIGN_IN = '/sign-in';
  static const INTRODUCE_YOURSELF = '/introduce-yourself';
  static const PROFILE_PREVIEW = '/PROFILE-PREVIEW';
  static const SIGN_UP_0 = '/sign-up-0';
  static const SIGN_UP_1 = '/sign-up-1';
  static const SIGN_UP_2 = '/sign-up-2';
  static const HOME_SCREEN = '/home';
  static const DASHBOARD = '/dashboard';
  static const EDIT_SLOTS = '/edit-slots';
  static const QUESTIONNAIRE = '/questionnaire';
  static const CHAT_SCREEN = '/chat-screen';
  static const WALLET = '/wallet';
  static const NOTES_SCREEN = '/notes-screen';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const SETTINGS = '/settings';
  static const VERIFY_RESET_ACCOUNT = '/verify-reset-account';
  static const UPDATE_PASSWORD = '/update-password';
  static const FORGOT_PASSWORD = '/forgot-password';
}
