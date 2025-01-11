import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class LocationRepo<T, F extends QueryParams> extends ApiService {
  Future<Either<ApiError, dynamic>> updateLocation(
      {required double latitude,
      required double longitude,
      required double timeZone,
      required String location,
      required String timeZoneIdentifier});
}
