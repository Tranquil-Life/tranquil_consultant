import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/screens/withdrawal_info.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/transaction_item.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  final earningsController = EarningsController.instance;
  NumberFormat? formatCurrency;

  double balance = 0;
  double pendingClearance = 0;
  double lifetimeTotalReceived = 0;

  @override
  void initState() {
    formatCurrency = NumberFormat.currency(
        locale: DashboardController.instance.country.value.toLowerCase() ==
                "nigeria"
            ? "en_NG"
            : "en_US",
        symbol: DashboardController.instance.country.value.toLowerCase() ==
                "nigeria"
            ? '₦'
            : "\$");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(
                color: ColorPalette.green[200], // Dark tint overlay
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(SvgElements.svgBalanceBgImg),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 24),
                          child: Column(children: [
                            const Text(
                              "Available Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorPalette.black),
                            ),
                            SizedBox(height: 4),
                            Wrap(
                                spacing: 25,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  GestureDetector(
                                      child: Icon(Icons.refresh_outlined,
                                          color:
                                          ColorPalette.black.withOpacity(.6)),
                                      onTap: () async {} // await getEarnings()
                                  ),
                                  FutureBuilder(
                                      future: earningsController.getBalance(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(formatCurrency!.format(0),
                                              style: TextStyle(
                                                  color: ColorPalette.green[800],
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: AppFonts
                                                      .josefinSansRegular));
                                        }

                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              'Error: ${snapshot.error}',
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          );
                                        }

                                        balance = snapshot.data!;

                                        return Text(
                                            formatCurrency!.format(balance),
                                            style: TextStyle(
                                                color: ColorPalette.green[800],
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                AppFonts.josefinSansRegular));
                                      }),
                                  Icon(Icons.visibility_outlined,
                                      color: ColorPalette.black.withOpacity(.6))
                                ]),
                            SizedBox(height: 12.5),
                            Obx(() => RichText(
                              text: TextSpan(
                                  text: "Total Balance: ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorPalette.black,
                                      fontFamily:
                                      AppFonts.josefinSansRegular),
                                  children: [
                                    TextSpan(
                                      text: formatCurrency!.format(
                                          earningsController
                                              .futurePayout.value +
                                              earningsController
                                                  .inTransit.value),
                                      style: TextStyle(
                                          color: ColorPalette.green[800],
                                          fontSize: AppFonts.defaultSize),
                                    ),
                                  ]),
                            ))
                          ]))
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: CustomButton(
                onPressed: () async{
                  var isEmpty = await checkForEmptyProfileInfo();
                  if(isEmpty){
                    Get.to(() => EditProfileScreen());
                  }else{
                    Get.to(WithdrawalInfoPage());
                  }
                },
                child: const Center(
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Withdraw to account',
                      style: TextStyle(
                          color: ColorPalette.white,
                          fontSize: AppFonts.defaultSize),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.arrow_downward,
                      color: ColorPalette.white,
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: FutureBuilder(
                        future: earningsController.getBalance(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return otherFigures('Future payouts', 0);
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          balance = snapshot.data!;

                          return otherFigures('Future payouts', balance);
                        })),

                Expanded(
                    child: FutureBuilder(
                        future: earningsController.getAmountInTransitToBank(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return otherFigures('In transit to bank', 0);
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          balance = snapshot.data!;

                          return otherFigures('In transit to bank', balance);
                        })),

                // otherFigures(
                //     'Available for \nwithdrawal', balance > 100 ? balance : 0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FutureBuilder(
                      future: earningsController.getPendingClearance(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return otherFigures('To be cleared', 0);
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        pendingClearance = snapshot.data!;

                        return otherFigures('To be cleared', pendingClearance);
                      }),
                ),
                Expanded(
                    child: FutureBuilder(
                        future: earningsController.getLifeTimeTotal(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return otherFigures('Lifetime volume received', 0);
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          lifetimeTotalReceived = snapshot.data!;
                          return otherFigures(
                              'Lifetime volume received', lifetimeTotalReceived);
                        }))
              ],
            ),
            const SizedBox(height: 40),
            const TransactionsSection(),
            SizedBox(height: 40)
          ]),
        ));
  }

  Container otherFigures(String title, double amount) {
    return Container(
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: ColorPalette.grey)),
        child: Center(
          child: Container(
              margin: const EdgeInsets.only(left: 4, right: 4),
              padding: const EdgeInsets.only(left: 4, right: 4),
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1, color: ColorPalette.grey[100]!)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Text(
                      title,
                      textAlign: TextAlign.center,
                    )),
                    Text(formatCurrency!.format(amount),
                        style: TextStyle(
                            fontFamily: AppFonts.josefinSansSemiBold,
                            fontSize: 18))
                  ],
                ),
              )),
        ));
  }
}
