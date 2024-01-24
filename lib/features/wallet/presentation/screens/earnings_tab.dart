import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/earnings_info.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/title_section.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/transaction_item.dart';

class EarningsTab extends StatefulWidget {
  const EarningsTab({Key? key}) : super(key: key);

  @override
  State<EarningsTab> createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  final earningsController =  Get.put(EarningsController());

  getEarnings() async{
    await Future.delayed(const Duration(seconds: 1));
    earningsController.getEarningsInfo();
  }

  @override
  void initState() {
    getEarnings();

    super.initState();
  }

  @override
  void dispose() {
    try {
      //earningsController.earningsStreamController.close();
    } catch (e) {
      log("DISPOSE: Error: $e");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          const TitleSection(),

          Scrollbar(
            child: RefreshIndicator(
              color: ColorPalette.green,
              onRefresh: () async => getEarnings(),
              child: Container(
                height: 238,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/earnings/earnings_info.png"),
                      fit: BoxFit.cover),
                ),
                child: EarningsInfo(earningsController: earningsController)
              ),
            ),
          ),

          const SizedBox(height: 32),

          CustomButton(
            onPressed: (){
              //TODO: Withdraw funds
            },
            text: "Withdraw",
          ),

          const SizedBox(height: 22),

          Transactions()

        ],
      )
    );
  }
}
