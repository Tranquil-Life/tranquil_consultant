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
  Future<Either<ApiError, dynamic>> updateProfile(Map<String, dynamic> req) async {
    return await catchSocketException(
            () => postReq(ProfileEndPoints.edit, body: req))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> uploadVideo(Map<String, dynamic> req) async{
    return await catchSocketException(
            () => postReq(MediaEndpoints.uploadFile, body: req))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> deleteQualification(int id) async{
    return await catchSocketException(
            () => postReq(ProfileEndPoints.deleteQualification, body: {'id': id}))
        .then((value) => handleResponse(value));
  }


}
