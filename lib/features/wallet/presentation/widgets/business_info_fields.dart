import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';

class BusinessInfoFields extends StatelessWidget {
  const BusinessInfoFields({super.key, required this.earningsController});

  final EarningsController earningsController;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("BUSINESS INFO",
          style: TextStyle(fontSize: AppFonts.baseSize)),
      SizedBox(height: 12),
      Text(
        "Business website",
        style: TextStyle(color: ColorPalette.grey[600]),
      ),
      const SizedBox(height: 8),
      websiteField(earningsController),
    ]);
  }
}
