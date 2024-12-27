import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/config.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/therapist_type.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  static const _text = [
    'Let\'s help people live better and tranquil lives',
    'Connect with a global clientele.'
  ];
  final _pageController = PageController();

  int page = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      var nextPage = _pageController.page!.round();
      if (nextPage != page) setState(() => page = nextPage);
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/onboarding/1.png'), context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _goToPage(int page) => _pageController.animateToPage(
    page,
    duration: kTabScrollDuration,
    curve: Curves.easeOutBack,
  );

  @override
  Widget build(BuildContext context) {
    var color = ColorPalette.green;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Align(
                alignment: const Alignment(0, -0.3),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _goToPage,
                    clipBehavior: Clip.none,
                    children: List.generate(
                      _text.length,
                          (i) => Center(
                        child: Image(
                          image: AssetImage('assets/images/onboarding/$i.png'),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 80,
                      child: Text(
                        _text[page],
                        style: const TextStyle(height: 1.5, fontSize: AppFonts.defaultSize),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _text.length,
                          (i) => AnimatedContainer(
                        duration: kThemeAnimationDuration,
                        width: page == i ? 40 : 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: page == i ? color : color.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16, right: 24, left: 24),
                      child: CustomButton(
                        text: page < _text.length - 1
                            ? "Next"
                            : "Continue",
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (page < _text.length - 1) {
                              _goToPage(page + 1);
                            } else {
                              //AppData.isOnboardingCompleted = true;
                              Get.offAll(AccountTypeScreen());
                            }
                          });

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


