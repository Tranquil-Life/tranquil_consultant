import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/activity/domain/repos/notification_repo.dart';


class NotificationRepoImpl extends NotificationRepo {
  @override
  Future<Either<ApiError, dynamic>> getNotifications(
      {required int page, required int limit}) async {
    return await catchSocketException(() => getReq(
            ActivityEndpoints.getNotifications(page: page, limit: limit)))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getUnreadNotificationCount() async {
    return await catchSocketException(() =>
        getReq(ActivityEndpoints.unreadNotifications)
            .then((value) => handleResponse(value)));
  }
}
