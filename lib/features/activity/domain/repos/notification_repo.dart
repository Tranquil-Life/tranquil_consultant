import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class NotificationRepo<T, F extends QueryParams> extends ApiService {
  NotificationRepo();

  Future<Either<ApiError, dynamic>> getNotifications(
      {required int page, required int limit});

  Future<Either<ApiError, dynamic>> getUnreadNotificationCount();
}
