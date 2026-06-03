import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/step_circle.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/verificiation_pages/license_info_page.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/verificiation_pages/pro_info_page.dart';

class VerifyEligibility extends StatefulWidget {
  const VerifyEligibility({super.key});

  @override
  State<VerifyEligibility> createState() => _VerifyEligibilityState();
}

class _VerifyEligibilityState extends State<VerifyEligibility> {
  final PageController _pageController = PageController();
  final verificationController = VerificationController.instance;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    verificationController.currentStep.value = 1;
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    if (verificationController.currentStep.value == 0) {
      Get.back();
    } else {
      verificationController.currentStep.value = 0;
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xff388D4D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: previousPage,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  const Text(
                    'Verify Eligibility',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2B2B2B),
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    stepCircle('1', verificationController.currentStep.value == 0),
                    Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: verificationController.currentStep.value == 0
                            ? green.withValues(alpha: 0.35)
                            : green,
                      ),
                    ),
                    stepCircle('2', verificationController.currentStep.value == 1),
                    const SizedBox(width: 12),
                    Text(
                      'Step ${verificationController.currentStep.value + 1} of 2',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  professionalInfoPage(verificationController, nextPage),
                  licenseInfoPage(verificationController, nextPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}