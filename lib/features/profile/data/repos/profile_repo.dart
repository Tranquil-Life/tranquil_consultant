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
  Future<Either<ApiError, dynamic>> updateProfile(User user) async {
    return await catchSocketException(
            () => postReq(ProfileEndPoints.edit, body: user.toJson()))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> currentContinent() async {
    return await catchSocketException(
            () => getReq(ProfileEndPoints.getContinent, false, true))
        .then((value) => handleResponse(value));
  }
}
