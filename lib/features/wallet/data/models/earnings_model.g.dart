part of 'earnings_model.dart';

_$EarningsModelFromJson(Map<String, dynamic> json) => EarningsModel(
    id: json['id'],
    userId: json['user_id'],
    balance: double.parse(json['net_income'].toString()),
    withdrawn: double.parse(json['withdrawn'].toString()),
    availableForWithdrawal:
        double.parse(json['available_for_withdrawal'].toString()),
    pendingClearance: double.parse(json['pending_clearance'].toString()),
    stripeAccountId: json['stripe_account_id']);
