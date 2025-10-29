import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/wallet/domain/entities/create_stripe_account.dart';
import 'package:tl_consultant/features/wallet/domain/repos/wallet_repo.dart';

class WalletRepositoryImpl extends WalletRepo {
  @override
  Future<Either<ApiError, dynamic>> getWallet() async {
    return await catchSocketException(() => getReq(WalletEndpoints.getWallet))
        .then((value) => handleResponse(value));
  }

  // @override
  // Future<Either<ApiError, dynamic>> getTransactions(
  //     {required int page, required int limit}) async {
  //   return await catchSocketException(() =>
  //           getReq(WalletEndpoints.getTransactions(page: page, limit: limit)))
  //       .then((value) => handleResponse(value));
  // }

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
      {required CreateStripeAccount params}) async {
    // Convert the params to Map
    final Map<String, dynamic> rawData = params.toJson();

    // Convert any File to MultipartFile
    final Map<String, dynamic> convertedData =
        await convertFilesToMultipart(rawData);

    return await catchSocketException(() =>
            postReq(WalletEndpoints.createConnectAccount, body: convertedData))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getStripeAccountInfo() async {
    return await catchSocketException(
            () => getReq(WalletEndpoints.getStripeAccountInfo))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getBalance() async {
    return await catchSocketException(
            () => getReq(WalletEndpoints.getAccountBalance))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getLifeTimeTotalReceived() async {
    return await catchSocketException(() =>
            getReq(WalletEndpoints.getLifeTimeConnectedTotalVolumeReceived))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getTotalPendingClearance() async {
    return await catchSocketException(
            () => getReq(WalletEndpoints.getPendingClearance))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> transferToConnectedAcc(
      {required int amount}) async {
    return await catchSocketException(() =>
        getReq(WalletEndpoints.transferToConnectedAccount(amount: amount)));
  }

  @override
  Future<Either<ApiError, dynamic>> withdrawToBankAcc(
      Map<String, dynamic> req) async {
    return await catchSocketException(
        () => postReq(WalletEndpoints.withdrawFromConnectedAccount, body: req));
  }

  @override
  Future<Either<ApiError, dynamic>> getAmountInTransitToBank() async {
    return await catchSocketException(
        () => getReq(WalletEndpoints.getAmountInTransitToBank));
  }

  @override
  Future<Either<ApiError, dynamic>> getStripeTransactions(
      {String? startingAfter, required String accountId}) async {
    return await catchSocketException(() => getReq(
        WalletEndpoints.getStripeTransactions(
            startingAfter: startingAfter, accountId: accountId)));
  }
}
