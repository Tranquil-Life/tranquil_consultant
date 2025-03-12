import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/transaction_item.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  final earningsController = Get.put(EarningsController());
  NumberFormat? formatCurrency;

  getEarnings() async {
    earningsController.getEarningsInfo();
  }

  @override
  void initState() {
    formatCurrency = NumberFormat.currency(locale: "en_NG", symbol: '₦');

    getEarnings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
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
                                    onTap: () async => await getEarnings()),
                                Text(
                                    formatCurrency!.format(
                                        earningsController.balance.value),
                                    style: TextStyle(
                                      color: ColorPalette.green[800],
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Icon(Icons.visibility_outlined,
                                    color: ColorPalette.black.withOpacity(.6))
                              ]),
                          SizedBox(height: 12.5),
                          RichText(
                            text: TextSpan(
                                text: "Total Balance: ",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorPalette.black,
                                    fontFamily: AppFonts.josefinSansRegular),
                                children: [
                                  TextSpan(
                                    text: formatCurrency!.format(
                                        earningsController.balance.value +
                                            earningsController
                                                .pendingClearance.value),
                                    style: TextStyle(
                                        color: ColorPalette.green[800],
                                        fontSize: AppFonts.defaultSize),
                                  ),
                                ]),
                          ),
                        ]))
                  ],
                )),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 48, right: 48),
            child: CustomButton(
              onPressed: () {},
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
              otherFigures(
                  'To be cleared', earningsController.pendingClearance.value),
              otherFigures('All withdrawals',
                  earningsController.availableForWithdrawal.value),
              otherFigures(
                  'Total earnings',
                  earningsController.balance.value +
                      earningsController.withdrawn.value),
            ],
          ),
          const SizedBox(height: 40),
          const TransactionsSection(),
          SizedBox(height: 40)

        ]));
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
                        style:
                            TextStyle(fontFamily: AppFonts.josefinSansSemiBold))
                  ],
                ),
              )),
        ));
  }
}
