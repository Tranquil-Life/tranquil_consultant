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
    return await catchSocketException(
            () => getReq(ConsultationEndPoints.getSlots))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> saveSlots(
      {List? slots, List? availableDays}) async {
    var body = {"available_time": slots, "available_days": availableDays};

    return await catchSocketException(
            () => postReq(ConsultationEndPoints.saveSlots, body: body))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getMeetings({required int page}) async {
    return await catchSocketException(
            () => getReq(ConsultationEndPoints.getMeetings(page: page)))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> deleteSlot() {
    // TODO: implement deleteSlot
    throw UnimplementedError();
  }
}
