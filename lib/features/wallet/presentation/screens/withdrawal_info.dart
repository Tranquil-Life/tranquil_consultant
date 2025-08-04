import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/account_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/bank_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/beneficiary_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/business_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/identity_verification_fields.dart';

class WithdrawalInfoPage extends StatefulWidget {
  const WithdrawalInfoPage({super.key});

  @override
  State<WithdrawalInfoPage> createState() => _WithdrawalInfoPageState();
}

class _WithdrawalInfoPageState extends State<WithdrawalInfoPage> {
  final earningsController = EarningsController.instance;
  NumberFormat? formatCurrency;

  bool isSelected = false;

  void toggleSelection(){
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  void initState() {
    formatCurrency = NumberFormat.currency(locale: "en_NG", symbol: '₦');

    if(earningsController.payoutExists()){
      isSelected = true;
    }

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
                    Text(
                      "Available balance: ${formatCurrency!.format(
                          earningsController.balance.value)}",
                      style: TextStyle(color: ColorPalette.green[500]),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                //Beneficiary info fields
                BeneficiaryInfoFields(earningsController: earningsController),

                SizedBox(height: 40),

                //bank info fields
                //TODO: Uncomment for Nigerian based therapist: requirements:
                // BankInfoFields(earningsController: earningsController),
                //
                // SizedBox(height: 40),

                //Account info fields
                AccountInfoFields(earningsController: earningsController),

                SizedBox(height: 40),

                BusinessInfoFields(earningsController: earningsController),

                SizedBox(height: 40),

                IdentityVerificationFields(earningsController: earningsController),

                SizedBox(height: 20),

                Row(
                  children: [
                   Obx(()=> Checkbox(
                     activeColor: ColorPalette.green,
                     value: earningsController.acceptedTOS.value,
                     onChanged: (value) {
                       earningsController.toggleTosAcceptance();
                     },
                   ),),

                    Text("Accept terms of service")
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      activeColor: ColorPalette.green,
                      value: isSelected,
                      onChanged: (value) {
                        if(!isSelected){
                          earningsController.createStripePayout();
                        }
                        toggleSelection();
                      },
                    ),

                    Text("Save details for later ")
                  ],
                ),

                SizedBox(height: 40),

                CustomButton(onPressed: (){
                  earningsController.createStripePayout();
                }, text: "Continue with withdrawal"),

                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
