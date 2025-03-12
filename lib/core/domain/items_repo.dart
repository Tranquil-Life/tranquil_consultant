import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class ItemsRepo<T> extends ApiService{
  ItemsRepo();

  //Future<Either<ResolvedError, T>> get();
  Future<Either<ApiError, List<T>>> getAll();
}