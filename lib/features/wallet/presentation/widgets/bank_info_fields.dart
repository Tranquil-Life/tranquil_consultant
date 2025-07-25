import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';

class BankInfoFields extends StatefulWidget {
  const BankInfoFields({super.key, required this.earningsController});

  final EarningsController earningsController;

  @override
  State<BankInfoFields> createState() => _BankInfoFieldsState();
}

class _BankInfoFieldsState extends State<BankInfoFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("BANK INFO",
            style: TextStyle(fontSize: AppFonts.baseSize)),
        SizedBox(height: 12),
        Text(
          "Bank name",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        bankNameField(widget.earningsController, () {}),
        SizedBox(height: 12),
        Text(
          "Bank address",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        bankAddressField(widget.earningsController, () {}),
      ],
    );
  }
}
