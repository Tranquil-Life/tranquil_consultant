import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/create_payout_account_section.dart';

class ShowCurrentPayoutAccount extends StatefulWidget {
  const ShowCurrentPayoutAccount({super.key});

  @override
  State<ShowCurrentPayoutAccount> createState() =>
      _ShowCurrentPayoutAccountState();
}

class _ShowCurrentPayoutAccountState extends State<ShowCurrentPayoutAccount> {
  final earningsController = EarningsController.instance;
  int length = 0;

  @override
  void initState() {
    earningsController.getStripeAccountInfo();
    earningsController.payoutExists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final accounts =
          earningsController.stripeAccountModel.value.externalAccounts?.data;
      length = accounts?.length ?? 0;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accounts list
            if (accounts == null)
              Center(
                  child: CircularProgressIndicator(color: ColorPalette.green))
            else if (accounts.isEmpty)
              Center(
                child: Text(
                  "No external accounts linked",
                  style: TextStyle(color: ColorPalette.grey[400]),
                ),
              )
            else
              Column(
                children: accounts
                    .map((e) => Container(
                          padding: EdgeInsets.all(16),
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorPalette.green[100],
                          ),
                          child: Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Icons.account_balance,
                                    color: ColorPalette.grey[400],
                                    size: 30,
                                  ),
                                  Positioned(
                                      top: 8,
                                      left: 12,
                                      child: Text(
                                        countryFlagGenerator(e.currency),
                                        style: TextStyle(fontSize: 25),
                                      ))
                                ],
                              ),
                              SizedBox(width: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.accountHolderName ?? "Unknown Holder",
                                    style: TextStyle(
                                        fontSize: AppFonts.baseSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${(e.currency ?? 'usd').toUpperCase()} account ending in ${e.last4 ?? '----'}",
                                        style: TextStyle(
                                            color: ColorPalette.grey[400]),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.remove_red_eye_outlined,
                                          color: ColorPalette.grey[400])
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),

            // SizedBox(height: 16),
            //
            // GestureDetector(
            //     onTap: () {
            //       // handle adding another account
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 16),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Create new withdrawal account",
            //             style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 color: ColorPalette.green[700],
            //                 fontSize: AppFonts.baseSize),
            //           ),
            //
            //           Icon(Icons.keyboard_arrow_right_outlined)
            //         ],
            //       ),
            //     )),

            // SizedBox(height: displayHeight(context) / (length * 4)),
            SizedBox(
                height:
                    length > 0 ? displayHeight(context) / (length * 4) : 16),
          ],
        ),
      );
    });
  }

  String countryFlagGenerator(String currency) {
    switch (currency) {
      case "USD":
        return countryCodeToEmoji("US");
      case "NGN":
        return countryCodeToEmoji("NG");
      default:
        return countryCodeToEmoji("US");
    }
  }
}
