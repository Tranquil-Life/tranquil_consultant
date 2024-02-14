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

    return await catchSocketException(() =>
            getReq(JournalEndPoints.sharedNotes(page: page, limit: limit)))
        .then((value) => handleResponse(value));
  }
}
