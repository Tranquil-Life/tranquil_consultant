import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_text.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  OnboardingController controller = Get.put(OnboardingController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      final bool isUserOnboarded = await controller.checkOnboardingStatus();

      if (isUserOnboarded) {
        controller.checkAuthStatus();
      } else {
        Get.toNamed(Routes.ONBOARDING);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          Align(
            alignment: const Alignment(0, -0.2),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
          ),
          Positioned(
            left: 50,
            right: 50,
            bottom: 48,
            child: Center(
              child: CustomText(
                text: 'A safe space to talk and feel without judgement.',
                textAlign: TextAlign.center,
                color: ColorPalette.white,
                size: isSmallScreen(context) ? AppFonts.baseSize : 18,
              )
            ),
          ),
        ],
      ),
    );
  }
}