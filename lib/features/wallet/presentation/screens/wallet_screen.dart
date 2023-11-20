import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tl_consultant/features/wallet/domain/entities/wallet_entity.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/wallet_controller.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({Key? key}) : super(key: key);

  // final bool reload;
  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  final controller = Get.put(WalletController());
  Wallet? _wallet;

  @override
  void initState() {
    //controller.walletInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
        ],
      ),
    );
  }

}