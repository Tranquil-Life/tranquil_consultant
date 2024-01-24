import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/earnings_info_content_item.dart';

class EarningsInfo extends StatefulWidget {
  const EarningsInfo({Key? key, required this.earningsController}) : super(key: key);

  final EarningsController earningsController;

  @override
  State<EarningsInfo> createState() => _EarningsInfoState();
}

class _EarningsInfoState extends State<EarningsInfo> {
  // getData(){
  //   widget.earningsController.netIncome.value = widget.data!['net_income'];
  //   widget.earningsController.withdrawn.value = widget.data!['withdrawn'];
  //   //widget.earningsController.pendingClearance.value = widget.data!['net_income'];
  //   widget.earningsController.availableForWithdrawal.value = widget.data!['available_for_withdrawal'];
  //   //widget.earningsController.expectedEarnings = widget.data!['net_income'];
  // }

  @override
  void initState() {
    //getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
    Stack(
      children: [
        Positioned(
            top: 20,
            left: 20,
            child: InfoContentItem(
                title: "Current Balance",
                amount: "\$${widget.earningsController.balance.value}")
        ),
        Positioned(
            top: 20,
            right: 20,
            child: InfoContentItem(
                title: "Withdrawn",
                amount: "\$${widget.earningsController.withdrawn.value}")
        ),

        const Positioned(
            bottom: 20,
            right: 20,
            child: InfoContentItem(
                title: "Pending \nClearance",
                amount: "")
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: InfoContentItem(
                title: "Available For \nWithdrawal",
                amount: "\$${widget.earningsController.availableForWithdrawal.value}")
        ),
      ],
    ));
  }
}
