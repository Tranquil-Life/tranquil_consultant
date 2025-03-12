import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/auth/domain/repos/auth_repo.dart';

final FirebaseMessaging _messaging = FirebaseMessaging.instance;

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either<ApiError, dynamic>> register(QueryParams params) async {
    if (kDebugMode) {
      print(params.toJson());
    }
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
  Future<Either<ApiError, dynamic>> signIn(String email,
      String password) async {
    final input = {"email": email, "password": password};
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
  Future<Either<ApiError, dynamic>> generateFcmToken() async {
    // Request permission for notifications
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      String? newToken = await _messaging.getToken();
      if (newToken != null) {
        return Right(newToken);
      } else {
        return const Left(ApiError(message: "Failed to generate fcm token"));
      }
    } catch (e) {
      print(e);
      return Left(ApiError(message: "$e"));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> sendTokenToEndpoint(String newToken) async {
    final input = {'token': newToken};

    return await catchSocketException(() =>
        postReq(AuthEndPoints.updateFcmToken, body: input))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> isAuthenticated() async {
    return await catchSocketException(() =>
        getReq(AuthEndPoints.checkAuthStatus))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> requestVerificationToken(
      {required String email}) async {
    var request = {"email": email};

    return await catchSocketException(() =>
        postReq(AuthEndPoints.requestVerificationToken, body: request))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> verifyAccount(String token) async {
    var request = {"token": token};

    return await catchSocketException(() =>
        postReq(AuthEndPoints.verifyAccount, body: request))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> requestResetPwdToken({required String email}) async{
    var request = {"email": email};

    return await catchSocketException(() =>
        postReq(AuthEndPoints.requestResetPwdToken, body: request))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> verifyResetToken(String token) async{
    var request = {"token": token};

    return await catchSocketException(() =>
        postReq(AuthEndPoints.verifyResetToken, body: request))
        .then((value) => handleResponse(value));
  }


  @override
  Future<Either<ApiError, dynamic>> updatePassword({required String token, required String password}) async{
    var request = {"token": token, 'password': password};

    return await catchSocketException(() =>
        postReq(AuthEndPoints.updatePassword, body: request))
        .then((value) => handleResponse(value));
  }



}
