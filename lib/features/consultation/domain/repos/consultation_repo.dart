import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class ConsultantRepo<T, F extends QueryParams> extends ApiService{
  Future<Either<ApiError, T>> getSlots();
  Future<Either<ApiError, T>> saveSlots();
  Future<Either<ApiError, T>> getMeetings({required int page});
  Future<Either<ApiError, T>> deleteSlot();
}