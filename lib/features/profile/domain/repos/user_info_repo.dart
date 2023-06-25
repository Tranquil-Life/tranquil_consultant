import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class UserInfoRepo<T, F extends QueryParams> extends ApiService {
  UserInfoRepo();

  Future<Either<ApiError, dynamic>> uploadCv(File file);
  Future<Either<ApiError, dynamic>> uploadID(File file);
  Future<Either<ApiError, dynamic>> updateInfo(String filePath);
}