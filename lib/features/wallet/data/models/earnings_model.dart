import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

part 'earnings_model.g.dart';

class EarningsModel extends Earnings{
  EarningsModel({
    super.id,
    super.userId,
    super.balance,
    super.availableForWithdrawal,
    super.withdrawn,
    super.pendingClearance,
    super.stripeAccountId
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) =>
      _$EarningsModelFromJson(json);
}