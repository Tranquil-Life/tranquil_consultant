import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/core/utils/routes/bindings/controllers_binding.dart';

import 'core/constants/constants.dart';
import 'main.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<FirebaseApp> initFirebase;

  @override
  void initState() {
    initFirebase = Firebase.initializeApp(
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initFirebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: rootMessengerKey,
            initialRoute: Routes.SPLASH_SCREEN,
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            // unknownRoute: GetPage(
            //   name: '/notfound',
            //   page: () =>
            //       const Scaffold(body: Center(child: Text("Page Not Found"))),
            // ),
            theme: ThemeData(
              scaffoldBackgroundColor: ColorPalette.white,
              primarySwatch: Colors.green,
              fontFamily: AppFonts.mulishRegular,
            ),
            getPages: AppPages.pages,
          );
        }

        // You can return a loading screen while waiting
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
