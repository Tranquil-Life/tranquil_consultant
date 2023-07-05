part of 'earnings_model.dart';

_$EarningsModelFromJson(Map<String, dynamic> json)=>EarningsModel(
  id: json['id'],
  userId: json['user_id'],
  netInCome: double.parse(json['net_income'].toString()),
  withdrawn: double.parse(json['withdrawn'].toString()),
  availableForWithdrawal: double.parse(json['available_for_withdrawal'].toString()),
);