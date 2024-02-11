import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';
import 'package:tl_consultant/features/wallet/domain/repos/wallet_repo.dart';

class WalletRepositoryImpl extends WalletRepo {
  @override
  Future<Either<ApiError, dynamic>> getWallet() async {
    return await catchSocketException(() => getReq(WalletEndpoints.getWallet))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getTransactions(
      {required int page, required int limit}) async {
    return await catchSocketException(() =>
            getReq(WalletEndpoints.getTransactions(page: page, limit: limit)))
        .then((value) => handleResponse(value));
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
