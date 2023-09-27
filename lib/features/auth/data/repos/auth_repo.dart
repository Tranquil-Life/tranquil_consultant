import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _messaging = FirebaseMessaging.instance;
class AuthRepoImpl extends AuthRepo{
  @override
  Future<Either<ApiError, dynamic>> isUserAuthenticated() async{
    try{
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(
          AuthEndPoints.isAuthenticated);

      if (!jsonEncode(response.body).contains('error')) {
        return Left(ApiError(
          message: response.body['message'],
        ));
      }
      else{
        if (response.body['user'] != null) {
          return Right(response.body['user']);
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

  @override
  Future<Either<ApiError, dynamic>> register(QueryParams params) async{
    try {
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(
          AuthEndPoints.register,
          body: params.toJson());
      print(response.body);

      if (!jsonEncode(response.body).contains('error')) {
        return Left(
            ApiError(
              message: response.body['message'],
            ));
      }
      else{
        if (response.body['user'] != null) {
          return Right(response.body['user']);
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

  @override
  Future<Either<ApiError, dynamic>> resetPassword(String email) async{
    try {
      final response = await postReq(
        AuthEndPoints.passwordReset,
        body: {'email': email},
      );

      if (response.data['error'] == false) {
        return const Right(true);
      } else {
        return Left(ApiError(message: response.data['message']));
      }

      return const Right(true);
    } catch (e) {
      return const Left(ApiError(
        message: 'There was am issue sending the email. Try again later',
      ));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> signIn(String email, String password) async{
    try {
      httpClient.baseUrl = baseUrl;
      
      final data = {
        "email": email,
        "password": password};

      Response response = await postReq(
          AuthEndPoints.login, body: data);
      print(response.body);
      // Refreshes FCM token whenever a user logs in
      String? newToken = await _messaging.getToken();
      print('Current FCM Token: $newToken');

      // Sends the current token to the endpoint
      await sendTokenToEndpoint(newToken!);
      if (!jsonEncode(response.body).contains('error')) {
        return Left(ApiError(
          message: response.body['message'],
        ));
      }
      else{
        if (response.body['user'] != null) {
          return Right(response.body['user']);
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

    } on SocketException catch (e) {
      return Left(ApiError(
          message: '$e'));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> signOut() async{
    try{
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(AuthEndPoints.logOut);

      if (response.body['error'] == false) {
        return Right(response.body);
      } else {
        return Left(ApiError(message: response.body['message']));
      }
    } on SocketException catch (e) {
      return const Left(ApiError(
          message: 'An Error Occurred Please check you network and retry'));
    }
  }
  Future<Either<ApiError, dynamic>> sendTokenToEndpoint(String newToken) async {
    try {
      httpClient.baseUrl = baseUrl;
      Response response = await postReq(AuthEndPoints.fcmToken, body: {'token': newToken},);

      if (response.statusCode == 200 ) {
        // Token sent successfully
        print('Token sent to database: $newToken');
                return Right('Token recorded successfully');
      } else {
        final errorMessage = 'Failed to update token: ${response.statusCode}';
        print(errorMessage);
        return Left(ApiError(message: errorMessage));
      }
    } on SocketException catch (e) {
      final errorMessage = 'Error sending token: $e';
      print(errorMessage);
      return Left(ApiError(message: errorMessage));
    }
  }
}