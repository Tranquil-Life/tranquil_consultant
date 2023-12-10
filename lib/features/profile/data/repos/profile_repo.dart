import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/domain/repos/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  ProfileRepoImpl();

  @override
  Future<Either<ApiError, User>> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> updateProfile(User user) async{
    try {
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(
        ProfileEndPoints.edit,
        body: user.toJson()
      );

      if (!jsonEncode(response.body).contains('error')) {
        return const Left(ApiError(
          message: "An Error Occurred Please check your network and retry",
        ));
      }
      else{
        if (response.body['profile'] != null) {
          return Right(response.body['profile']);
        }
        else if (response.body['errors'] is List) {
          final List<String>? errors = (response.body['errors'] as List?)?.cast();
          return Left(ApiError(
            message: errors?.fold('', (prev, next) => '$prev\n$next').trim(),
          ));
        }
        else {
          return Left(ApiError(
            message: response.body['message'],
          ));
        }
      }

    }
    on SocketException catch(e) {
      return Left(ApiError(
          message: e.toString()));
    }
  }

}
