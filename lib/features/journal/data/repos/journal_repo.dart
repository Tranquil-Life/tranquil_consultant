import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/journal/domain/repos/journal_repo.dart';

class JournalRepoImpl extends JournalRepo {
  @override
  Future<Either<ApiError, dynamic>> getJournal(
      {required int page, required int limit}) async {
    try {
    await Future.delayed(Duration(seconds: 2));
      httpClient.baseUrl = baseUrl;

      Response response =
          await getReq(JournalEndPoints.sharedNotes(page: page, limit: limit));

      if (response.body['error'] == false) {
        var data = response.body['data'];

        return Right(data);
      } else {
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }
    } on SocketException catch (e) {
      return Left(ApiError(message: e.toString()));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
  }
}
