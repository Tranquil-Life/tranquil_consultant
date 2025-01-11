import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/config.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/routes/bindings/controllers_binding.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: "1:16125004014:web:1a1ccb278c740a6d5f8bff",
        apiKey: "AIzaSyDvEsztETqHYAwfJx0ocpjPTZccMNDMc-k",
        projectId: 'tranquil-life-llc',
        messagingSenderId: '16125004014',
        databaseURL: "https://tranquil-life-llc-default-rtdb.firebaseio.com",
        measurementId: "G-ZRTEN0GQKV",
        storageBucket: "tranquil-life-llc.appspot.com",
        authDomain: "tranquil-life-llc.firebaseapp.com",
      ),
    );
    print('Initialized default app $app');
  }

  @override
  void initState() {
    initializeDefault();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarBrightness(true);
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: AppFonts.josefinSansRegular,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AllControllerBindings(),
    );
  }
}
