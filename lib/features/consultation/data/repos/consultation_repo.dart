import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/consultation/domain/repos/consultation_repo.dart';

class ConsultationRepoImpl extends ConsultantRepo {
  ConsultationRepoImpl();

  @override
  Future<Either<ApiError, dynamic>> getSlots() async {
    httpClient.baseUrl = baseUrl;
    try {
      Response response = await getReq(
          ConsultationEndPoints.getSlots);

      if (response.body['error'] == false) {
        var data = response.body['data'];

        return Right(data);
      } else {
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }
    } on SocketException catch (e) {
      return Left(ApiError(
          message: 'Error: $e'));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> saveSlots() {
    // TODO: implement editSlots
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> getMeetings() async{
    httpClient.baseUrl = baseUrl;

    try{
      Response response = await getReq(
          ConsultationEndPoints.getMeetings);

      if (response.body['error'] == false) {
        var data = response.body['meetings'];

        print("RESPONSE: $data");

        return Right(data);
      } else {

        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }

    }on SocketException catch (e) {
      return Left(ApiError(
          message: 'Error: $e'));
    }catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> deleteSlot() {
    // TODO: implement deleteSlot
    throw UnimplementedError();
  }

}