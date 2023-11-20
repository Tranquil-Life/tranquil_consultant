library app_pages;

import 'package:get/get.dart';
import 'package:tl_consultant/features/auth/presentation/screens/sign_in/sign_in.dart';
import 'package:tl_consultant/features/auth/presentation/screens/sign_up/sign_up_0.dart';
import 'package:tl_consultant/features/auth/presentation/screens/sign_up/sign_up_1.dart';
import 'package:tl_consultant/features/auth/presentation/screens/sign_up/sign_up_2.dart';
import 'package:tl_consultant/features/consultation/presentation/screens/edit_slots.dart';
import 'package:tl_consultant/features/dashboard/presentation/screens/dashboard.dart';
import 'package:tl_consultant/features/journal/presentation/screens/journal_tab.dart';
import 'package:tl_consultant/features/onboarding/presentation/screens/onboarding.dart';
import 'package:tl_consultant/features/onboarding/presentation/screens/splash.dart';
import 'package:tl_consultant/features/profile/presentation/screens/profile_tab.dart';
import 'package:tl_consultant/features/settings/presentation/screens/settings_screen.dart';
import 'package:tl_consultant/features/wallet/presentation/screens/wallet_screen.dart';


part 'app_routes.dart';

class AppPages{
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(name: Routes.SPLASH_SCREEN, page: ()=> SplashScreen()),
    GetPage(name: Routes.ONBOARDING, page: ()=> const OnBoardingScreen()),
    GetPage(name: Routes.SIGN_UP_0, page: ()=> SignUpScreen0()),
    GetPage(name: Routes.SIGN_UP_1, page: () => SignUpScreen1()),
    GetPage(name: Routes.SIGN_UP_2, page: () => SignUpScreen2()),
    GetPage(name: Routes.SIGN_IN, page: () => SignInScreen()),
    GetPage(name: Routes.DASHBOARD, page: () => const Dashboard()),
    GetPage(name: Routes.EDIT_SLOTS, page: () => EditSlots()),
    // GetPage(name: Routes.HOME_SCREEN, page: () => const HomeTab()),
    // GetPage(name: Routes.SCHEDULE_MEETING, page: () => const ScheduleMeetingScreen()),
    // GetPage(name: Routes.CONSULTANT_LIST, page: () => const ConsultantsListPage()),
    // GetPage(name: Routes.QUESTIONNAIRE, page: () => const QuestionsScreen()),
    // GetPage(name: Routes.QUESTIONS_DETAILS, page: () => const QuestionDetailsScreen()),
    // GetPage(name: Routes.CHAT_SCREEN, page: () => const ChatScreen()),
    GetPage(name: Routes.NOTES_SCREEN, page: () => const JournalTab()),
    GetPage(name: Routes.WALLET, page: () => WalletTab()),
    // GetPage(name: Routes.CUSTOMIZE_CARD, page: () => const CustomizeCardScreen()),
    GetPage(name: Routes.PROFILE, page: () => ProfileScreen()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsScreen()),
  ];

}