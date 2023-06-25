import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/journal/data/models/note.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';
import 'package:tl_consultant/features/journal/domain/repos/journal_repo.dart';

class JournalRepoImpl extends JournalRepo{
  @override
  Future<Either<ApiError, dynamic>> getJournal() async{
    try {
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(JournalEndPoints.getNotes);

      var data = response.body;

      if (data.containsKey('data')) {
        var notes = (response.body['data'] as List)
            .map((e) => NoteModel.fromJson(e));
        return Right(notes.toList());
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