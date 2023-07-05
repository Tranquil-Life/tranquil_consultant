import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

part 'earnings_model.g.dart';

class EarningsModel extends Earnings{
  EarningsModel({
    super.id,
    super.userId,
    super.netInCome,
    super.availableForWithdrawal,
    super.expectedEarnings,
    super.pendingClearance,
    super.withdrawn
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) =>
      _$EarningsModelFromJson(json);
}