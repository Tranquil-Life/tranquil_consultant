import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/domain/repos/earnings_repo.dart';

class EarningsRepoImpl extends EarningsRepo {
  @override
  Future<Either<ApiError, dynamic>> getInfo() async {
    try {
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(EarningsEndpoints.getInfo);

      var data = response.body;

      print(data);

      if (data.containsKey('data')) {
        var earningsInfo = response.body['data'];
        return Right(earningsInfo);
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
}
