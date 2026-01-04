import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/dashboard/domain/repo/location_repo.dart';

class LocationRepoImpl extends LocationRepo {
  @override
  Future<Either<ApiError, dynamic>> updateLocation(
      {required double latitude,
      required double longitude,
      required double timeZone,
      required String location,
      required String timeZoneIdentifier}) async {
    final input = {
      'latitude': latitude,
      'longitude': longitude,
      'time_zone': timeZone,
      'location': location,
      'timezone_identifier': timeZoneIdentifier,
    };
    return await catchSocketException(
            () => postReq(ProfileEndPoints.updateLocation, body: input))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> reverseGeocode(
      {required double latitude, required double longitude}) async {
    return await catchSocketException(() => getReq(
            GoogleMapsEndpoints.reverseGeocode(lat: latitude, lng: longitude)))
        .then((value) => handleResponse(value));
  }
}
