import 'package:flutter/material.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/earnings_info_content_item.dart';

class EarningsInfo extends StatefulWidget {
  const EarningsInfo({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic>? data;


  @override
  State<EarningsInfo> createState() => _EarningsInfoState();
}

class _EarningsInfoState extends State<EarningsInfo> {
  getData(){
    EarningsController.instance.netIncome.value = widget.data!['net_income'];
    EarningsController.instance.withdrawn.value = widget.data!['withdrawn'];
    //EarningsController.instance.pendingClearance.value = widget.data!['net_income'];
    EarningsController.instance.availableForWithdrawal.value = widget.data!['available_for_withdrawal'];
    //EarningsController.instance.expectedEarnings = widget.data!['net_income'];
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 20,
            left: 20,
            child: InfoContentItem(
                title: "Net Income",
                amount: "\$${EarningsController.instance.netIncome.value}")
        ),
        Positioned(
            top: 20,
            right: 20,
            child: InfoContentItem(
                title: "Withdrawn",
                amount: "\$${EarningsController.instance.withdrawn.value}")
        ),
        Align(
            child: InfoContentItem(
                title: "Available For Withdrawal",
                amount: "\$${EarningsController.instance.availableForWithdrawal.value}")
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: InfoContentItem(
                title: "Withdrawn",
                amount: "\$${EarningsController.instance.pendingClearance.value}")
        ),

        Positioned(
            bottom: 20,
            left: 20,
            child: InfoContentItem(
                title: "Expected Earnings",
                amount: "\$${EarningsController.instance.expectedEarnings.value}")
        ),
      ],
    );
  }
}
