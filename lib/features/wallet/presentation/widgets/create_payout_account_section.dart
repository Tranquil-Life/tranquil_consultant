import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/account_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/beneficiary_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/business_info_fields.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/identity_verification_fields.dart';

class CreatePayoutAccountSection extends StatelessWidget {
  const CreatePayoutAccountSection({super.key, required this.earningsController });

  final EarningsController earningsController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              value: earningsController.isSaved.value,
              onChanged: (value) {
                if(!earningsController.isSaved.value && earningsController.stripeAccountId.isEmpty){
                  earningsController.createStripePayout();
                }else if(!earningsController.isSaved.value && earningsController.stripeAccountId.isNotEmpty){
                  earningsController.updateStripePayout();
                }
                earningsController.toggleSave();
              },
            ),

            Text("Save details for later ")
          ],
        ),

        SizedBox(height: 40),
      ],
    );
  }
}
