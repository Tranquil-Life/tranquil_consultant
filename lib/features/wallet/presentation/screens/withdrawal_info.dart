import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/create_payout_account_section.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/show_current_payout_account.dart';

class WithdrawalInfoPage extends StatefulWidget {
  const WithdrawalInfoPage({super.key});

  @override
  State<WithdrawalInfoPage> createState() => _WithdrawalInfoPageState();
}

class _WithdrawalInfoPageState extends State<WithdrawalInfoPage> {
  final earningsController = EarningsController.instance;
  final dashboardController = DashboardController.instance;

  NumberFormat? formatCurrency;

  // bool isSelected = false;
  //
  // void toggleSelection(){
  //   setState(() {
  //     isSelected = !isSelected;
  //   });
  // }

  @override
  void initState() {
    formatCurrency = NumberFormat.currency(
        locale: dashboardController.country.value.toLowerCase() ==
                "nigeria"
            ? "en_NG"
            : "en_US",
        symbol: dashboardController.country.value.toLowerCase() ==
                "nigeria"
            ? '₦'
            : "\$");

    // earningsController.getStripeAccountInfo();
    earningsController.payoutExists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
      child: Scaffold(
        backgroundColor: ColorPalette.white,
        appBar: CustomAppBar(
          hideBackButton: false,
          centerTitle: false,
          title: withdrawFundsTitle,
          onBackPressed: () async{
            if(!kIsWeb){
              Get.back();

            }else{
              if (Get.key.currentState?.canPop() ?? false) {
                Get.back();
              } else {
                Get.offAllNamed(Routes.DASHBOARD);// fallback route
                await Future.delayed(const Duration(milliseconds: 500));
                dashboardController.currentIndex.value = 3;
              }
            }

          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  withdrawFundsDesc,
                  style: TextStyle(color: ColorPalette.grey[800]),
                ),
                SizedBox(height: 40),
                Text(
                  "Amount to withdraw",
                  style: TextStyle(color: ColorPalette.grey[600]),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //type amount field
                    amountField(earningsController),
                    //TODO: Remember to uncomment
                    // Text(
                    //   "Available balance: ${formatCurrency!.format(
                    //       balance)}",
                    //   style: TextStyle(color: ColorPalette.green[500]),
                    // ),
                  ],
                ),
                SizedBox(height: 40),
                if (stripeAccountId == null)
                  CreatePayoutAccountSection(
                      earningsController: earningsController)
                else
                  ShowCurrentPayoutAccount(),

                if (stripeAccountId == null)
                CustomButton(
                    onPressed: () {
                      earningsController.createStripePayout();
                    },
                    text: "Create payout account")
                else
                  CustomButton(
                      onPressed: () {
                        earningsController.withdrawEarnings();
                      },
                      text: "Continue with withdrawal"),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
