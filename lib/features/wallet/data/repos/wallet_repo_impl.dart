import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';
import 'package:tl_consultant/features/wallet/domain/entities/stripe_account.dart';
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

  String getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<Either<ApiError, dynamic>> getStates({required String country}) async {
    String url =
        countriesNowBaseUrl + CountriesNowEndpoints.getStates(country: country);

    var response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return Right(response.data);
    } else {
      return Left(ApiError(message: response.data['msg'] ?? "Unknown error"));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getCities(
      {required String country, required String state}) async {
    String url = countriesNowBaseUrl +
        CountriesNowEndpoints.getCities(country: country, state: state);

    var response = await dio.get(
      url,
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
        validateStatus: (status) => true, // <— for debugging
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return Right(response.data);
    } else {
      return Left(ApiError(
          message: response.data['msg'].toString() ?? "Unknown error"));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getCountries() {
    // TODO: implement getCountries
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> getBankBranches(
      {required String bankName, required String state}) async {
    String url =
        GoogleMapsEndpoints.getBankBranches(bankName: bankName, state: state);

    var response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return Right(response.data);
    } else {
      return Left(ApiError(message: response.data));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getFromNextPage(
      {required String nextPageToken}) async {
    String url =
        GoogleMapsEndpoints.getFromNextPage(nextPageToken: nextPageToken);

    var response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return Right(response.data);
    } else {
      return Left(ApiError(message: response.data));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> createStripeAccount(
      {required StripeAccount params}) async {
    // Convert the params to Map
    final Map<String, dynamic> rawData = params.toJson();

    // Convert any File to MultipartFile
    final Map<String, dynamic> convertedData =
        await convertFilesToMultipart(rawData);

    return await catchSocketException(() => postReq(
        WalletEndpoints.createConnectAccount,
        body: convertedData)).then((value) => handleResponse(value));
  }
}
