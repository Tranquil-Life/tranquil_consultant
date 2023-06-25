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

class AuthRepoImpl extends AuthRepo{
  @override
  Future<Either<ApiError, dynamic>> isUserAuthenticated() async{
    try{
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(
          AuthEndPoints.isAuthenticated);

      if (!jsonEncode(response.body).contains('error')) {
        return const Left(ApiError(
          message: "An Error Occurred Please check your network and retry",
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
          body: {
            "email": "apple4@gmail.com",
            "password": "password", "phone": "+18886666669",
            "f_name": "Applegate",
            "l_name": "Arguik",
            "birth_date": "25-07-1975",
            "cv_url": "https://storage.googleapis.com/tranquil-life-llc.appspot.com/cv/Applegate_Arguik_cv.docx?GoogleAccessId=firebase-adminsdk-znkhx%40tranquil-life-llc.iam.gserviceaccount.com&Expires=2634488863&Signature=ZqXYIVZw3Rz%2FmhrxmGI4XEYlT8ynvPAZoqUR4SvsiPmHoJO%2F%2BjsYqKVohkBJBl9XsH0WKwPUbtTaC9I3raZgKJJJWiASc9kVnBEpDHsJT1xONlv18lS%2B%2Fb5yY%2FZ3kBIzAVWOE76HPV6qRR740fgopAE0H7MhGC3ENLgjsR8DQJDNlSJ0qYSoAY%2BmPxyT2nEyq411AS8NDPYDDPob7dtkLf%2F2iLsIH3B1KyKmd0oO4kOEbH07uTMFLpJX%2FpHBgwqDMX0rdVl9yhHVzF4b%2BrqD86lvo%2Fz5D7HjK66%2BaLlVhlJaGVNA8i66YAXsPBpzvvoCjK2uzGC%2F8H1eqGAQogvj8g%3D%3D", "identity_front_url": "https://storage.googleapis.com/tranquil-life-llc.appspot.com/photo_id/Applegate_Arguik_photo_id.jpg?GoogleAccessId=firebase-adminsdk-znkhx%40tranquil-life-llc.iam.gserviceaccount.com&Expires=2634488893&Signature=Ar2U0kf%2F%2F4WSzQxAFfgWMyQD9WgpLGFhDRObmcMcEL6y5EhBW9%2FuGX18EjwembA7pVbyx4sZYMIPTzgsnwsTm52Au7O0U8vfv5q37d1QMgRb05ABf8cHEKCpAyXcoCwZ%2FDbPZDEl0CtbTckW5Ncg%2Fck9vC76%2F%2F0lZ9LjPdjrTB5UepjeXjJVicNu3QxbCXrIu%2BaO1%2Bny%2Bkq9lKU5qyL2z%2FvGBm7rvNBDWu3Tz75FpR5mUn1ryAkPT7gwMOrD7BdfCKagRwK413kAjpZOYmZZe8S4MGGqE67X0gFsKRq099i6vKGdqfZ3zswvOQC6OakR0YW%2F0JxI1ApDx3p5j%2BXkhw%3D%3D", "location": "Rivers, Nigeria", "linkedin_url": "Https//:", "specialties": ["Addiction & Recovery", "Boundary Issues", "Relationship Issues"], "years": "15 - 20", "languages": ["Chinese (Traditional)", "Hebrew", "Italian"], "employment_status": "employed"});

      print(response.body);

      if (!jsonEncode(response.body).contains('error')) {
        return const Left(
            ApiError(
              message: "An Error Occurred Please check your network and retry",
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

}