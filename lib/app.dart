import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/routes/bindings/controllers_binding.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/features/onboarding/presentation/screens/splash.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tranquil Life',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        fontFamily: AppFonts.josefinSansRegular,
        primaryColor: ColorPalette.green,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AllControllerBindings(),
    );
  }
}
