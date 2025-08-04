import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';

class AccountInfoFields extends StatefulWidget {
  const AccountInfoFields({super.key, required this.earningsController});

  final EarningsController earningsController;

  @override
  State<AccountInfoFields> createState() => _AccountInfoFieldsState();
}

class _AccountInfoFieldsState extends State<AccountInfoFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ACCOUNT INFO",
            style: TextStyle(fontSize: AppFonts.baseSize)),
        SizedBox(height: 12),

        Text(
          "Account number",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        accountNumberField(widget.earningsController),

        SizedBox(height: 12),

        Text(
          "Routing number",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        routingNumberField(widget.earningsController),

        SizedBox(height: 12),

        Text(
          "Account holder name",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        holderNameField(widget.earningsController),

        SizedBox(height: 12),

        Text(
          "Social security number",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        ssnField(widget.earningsController),

        SizedBox(height: 12),

        // Text(
        //   "IBAN",
        //   style: TextStyle(color: ColorPalette.grey[600]),
        // ),
        // const SizedBox(height: 8),
        // ibanField(widget.earningsController),
        //
        // SizedBox(height: 12),
        // Text(
        //   "Swift code",
        //   style: TextStyle(color: ColorPalette.grey[600]),
        // ),
        // const SizedBox(height: 8),
        // swiftCodeField(widget.earningsController),
      ],
    );
  }
}
