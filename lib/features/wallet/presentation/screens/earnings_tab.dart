import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/earnings_info.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/transaction_item.dart';

class EarningsTab extends StatefulWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  State<EarningsTab> createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  final earningsController = Get.put(EarningsController());

  getEarnings() async {
    earningsController.getEarningsInfo();
  }

  @override
  void initState() {
    getEarnings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(12),
          child: Scrollbar(
              child: RefreshIndicator(
                  onRefresh: () async => getEarnings(),
                  child: ListView(
                    children: [
                      Container(
                        height: 268,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/earnings/earnings_info.png"),
                              fit: BoxFit.cover),
                        ),
                        child: Center(
                            child: EarningsInfo(
                                earningsController: earningsController)),
                      ),
                      SizedBox(height: 16,),
                      CustomButton(
                        onPressed: () {
                          //TODO: Withdraw funds
                        },
                        text: "Withdraw",
                      ),
                      const SizedBox(height: 22),
                      const Transactions()
                    ],
                  )))),
    );
  }
}

