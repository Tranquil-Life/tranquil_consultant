import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either<ApiError, dynamic>> register(QueryParams params) async {
    return await catchSocketException(
            () => postReq(AuthEndPoints.register, body: params.toJson()))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> resetPassword(String email) async {
    final input = {'email': email};

    return await catchSocketException(
            () => postReq(AuthEndPoints.passwordReset, body: input))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> signIn(
      String email, String password) async {
    final input = {"email": email, "password": password};
    print("input: $input");
    return await catchSocketException(
            () => postReq(AuthEndPoints.login, body: input))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> signOut() async {
    return await catchSocketException(() => postReq(AuthEndPoints.logOut))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> refreshFcmToken(String fcmToken) {
    // TODO: implement refreshFcmToken
    throw UnimplementedError();
  }


}
