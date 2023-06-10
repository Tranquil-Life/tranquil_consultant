import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';

class NetworkController extends GetxController{
  static NetworkController instance = Get.find();

  var connectionStatus = 0.obs;

  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  @override
  void onInit() {
    initConnectivity();
    connectivitySubscription = connectivity.onConnectivityChanged.listen(updateConnectionStatus);

    super.onInit();
  }

  Future<void> initConnectivity() async{
    ConnectivityResult? result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch(e)
    {
      print("Network: Error: $e");
    }
    return updateConnectionStatus(result!);
  }

  Future<void> updateConnectionStatus(ConnectivityResult? result) async {
    switch(result!){
      case ConnectivityResult.wifi:
        connectionStatus.value = 2;
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = 1;
        break;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        break;
      default:
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Network Error",
            message: "Failed to get network connection",
            backgroundColor: ColorPalette.red);
        break;
    }

  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    super.onClose();
  }
}