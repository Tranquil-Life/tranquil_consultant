import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/timezone_converter.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/transactions_controller.dart';

part 'transactions_section.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {super.key,
      required this.amount,
      required this.time,
      required this.withdrawn});

  final String amount;
  final String time;
  final bool withdrawn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: ColorPalette.green[100],
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(withdrawn ? "Withdrawal" : "Session payment",
              style: TextStyle(fontFamily: AppFonts.josefinSansBold)),
          Text(
            withdrawn ? "- $amount" : amount,
            style: TextStyle(
                color: withdrawn ? ColorPalette.red : ColorPalette.green[800],
                fontFamily: AppFonts.josefinSansBold),
          ),
          Text(time)
        ],
      ),
    );
  }
}
