import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tl_consultant/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const App());

}
