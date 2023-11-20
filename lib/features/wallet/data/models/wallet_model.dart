import 'dart:convert';

import 'package:tl_consultant/features/wallet/domain/entities/wallet_entity.dart';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel extends Wallet {
  const WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
  }) : super(balance: balance);

  final int id;
  final int userId;
  final int balance;

  WalletModel copyWith({
    int? id,
    int? userId,
    int? balance,
    int? discount,
  }) =>
      WalletModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        balance: balance ?? this.balance,
      );

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    id: json["id"],
    userId: json["user_id"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "balance": balance,
  };
}