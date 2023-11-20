import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/wallet/data/models/wallet_model.dart';
import 'package:tl_consultant/features/wallet/domain/entities/wallet_entity.dart';
import 'package:tl_consultant/features/wallet/domain/repos/wallet_repo.dart';


class WalletRepositoryImpl extends WalletRepo {
  @override
  Future<Either<ApiError, Wallet>> getWallet() async {
    try {
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(WalletEndpoints.getWallet);

      if (response.body['error'] == false) {
        var wallet = WalletModel.fromJson(response.body['wallet']);
        return Right(wallet);
      } else {
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }


    } on SocketException catch (e) {
      return Left(ApiError(
          message: e.message));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
          message:
          e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getTransactions({required int page, required int limit}) async{
    try {
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(
          WalletEndpoints.getTransactions(
              page: page, limit: limit));

      var data = response.body;

      if (data.containsKey('data')) {
        return Right(response.body['data']);
      }
      return Left(ApiError(message: response.body['message']));
    } on SocketException catch (e) {
      return Left(ApiError(
          message: e.toString()));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
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