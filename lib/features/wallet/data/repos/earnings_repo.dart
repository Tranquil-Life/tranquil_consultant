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
  Future<Either<ApiError, dynamic>> getInfo() {
    // TODO: implement getInfo
    throw UnimplementedError();
  }

}
