import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

abstract class ProfileRepo<T, F extends QueryParams> extends ApiService {
  ProfileRepo();

  Future<Either<ApiError, dynamic>> updateProfile(User user);
  Future<Either<ApiError, dynamic>> currentContinent();
}
