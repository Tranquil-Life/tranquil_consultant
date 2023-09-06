import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';

class PreventScreenShot extends GetxController {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
