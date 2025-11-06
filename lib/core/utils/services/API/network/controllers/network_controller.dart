import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();

  var connectionStatus = 0.obs;

  final Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();

    connectivitySubscription = connectivity.onConnectivityChanged.listen(
      updateConnectionStatus,
    );
  }

  Future<void> initConnectivity() async {
    try {
      final result = await connectivity.checkConnectivity();
      updateConnectionStatus(result);
    } catch (e) {
      print("Network: Error: $e");
    }
  }

  Future<void> updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.isEmpty) return;
    final result = results.first;

    switch (result) {
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
        connectionStatus.value = 0;
    }
  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    super.onClose();
  }
}
