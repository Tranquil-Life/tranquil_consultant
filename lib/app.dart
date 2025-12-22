import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/core/utils/routes/bindings/controllers_binding.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    setStatusBarBrightness(true);
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: AppFonts.mulishRegular,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // unknownRoute: GetPage(
      //   name: '/404',
      //   page: () => const Scaffold(body: Center(child: Text('Route not found'))),
      // ),
      // initialBinding: AllControllerBindings(),
    );
  }
}
