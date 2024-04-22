import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/earnings_info_content_item.dart';

class EarningsInfo extends StatefulWidget {
  const EarningsInfo({Key? key, required this.earningsController})
      : super(key: key);

  final EarningsController earningsController;

  @override
  State<EarningsInfo> createState() => _EarningsInfoState();
}

class _EarningsInfoState extends State<EarningsInfo> {
    NumberFormat? formatCurrency ;

  @override
  void initState() {
    formatCurrency = NumberFormat.currency(locale: "en_NG", symbol: '₦');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoContentItem(
                        title: "Current Balance",
                        amount: formatCurrency!.format(widget.earningsController.balance.value)),
                    InfoContentItem(
                        title: "Withdrawn",
                        amount: formatCurrency!.format(widget.earningsController.withdrawn.value)
                            )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoContentItem(
                        title: "Pending \nClearance",
                        amount: formatCurrency!.format(widget.earningsController.pendingClearance.value)
                            ),
                    InfoContentItem(
                        title: "Available For \nWithdrawal",
                        amount:formatCurrency!.format(widget.earningsController.availableForWithdrawal.value)
                          )
                  ],
                )
              ],
            )
        );
  }
}
