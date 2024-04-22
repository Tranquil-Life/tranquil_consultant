import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';

part 'transactions.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {Key? key,
      required this.amount,
      required this.time,
      required this.withdrawn})
      : super(key: key);

  final String amount;
  final String time;
  final bool withdrawn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(color: ColorPalette.green[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(withdrawn ? "Withdrawal" : "Session payment", style: TextStyle(
                fontFamily: AppFonts.josefinSansBold)),
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

/**
 * Padding(
      padding: EdgeInsets.only(top: 8),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(top: 8),
              child: Text("${withdrawn ? "-" :""}$amount", style: TextStyle(fontSize: AppFonts.defaultSize),),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                width: 120,
                height: 31,
                decoration: BoxDecoration(
                    color: withdrawn ? ColorPalette.red.shade400: ColorPalette.green,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(width: 2, color: withdrawn ? ColorPalette.red : ColorPalette.green),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
                    ]
                ),
                child: Center(
                  child: Text(
                      withdrawn ? "Withdrawn" : "Received",
                      style: const TextStyle(fontSize: AppFonts.defaultSize, color: Colors.white)
                  ),
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(top: 8),
              child: Text(time, style: TextStyle(fontSize: AppFonts.defaultSize)),
            ),
          ),
        ],
      ),
    )
 */