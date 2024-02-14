import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class ApiData {
  final int? statusCode;
  final dynamic data;

  const ApiData(this.data, this.statusCode);
}

class ApiService {
  Map<String, String> _getHeaders() {
    User client = UserModel.fromJson(userDataStore.user);

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${client.authToken}',
    };
  }

  Future<Either<ApiError, dynamic>> handleResponse(
      Either<ApiError, dynamic> eitherResponse) async {
    return eitherResponse.fold(
      (apiError) => Left(apiError),
      (data) {
        return Right(data);
      },
    );
  }

  Future<Either<ApiError, dynamic>> catchSocketException(
      Function function) async {
    try {
      return await function();
    } on SocketException catch (e) {
      return Left(ApiError(message: 'Error: $e'));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(message: e.toString()));
    }
  }

  Future<Either<ApiError, dynamic>> getReq(String subPath,
      [bool exchange = false, bool countries = false]) async {
    final headers = _getHeaders();

    if (countries) {
      var result = await http.get(Uri.parse((subPath)));

      if (result.statusCode == 200) {
        return Right(jsonDecode(result.body));
      } else {
        return Left(ApiError(message: 'HTTP Error: ${result.statusCode}'));
      }
    } else {
      var result = await http.get(
          Uri.parse((exchange ? "" : baseUrl) + subPath),
          headers: headers);

      await Future.delayed(const Duration(seconds: 1));

      if (result.statusCode == 200) {
        return Right(jsonDecode(result.body));
      } else {
        return Left(ApiError(message: 'HTTP Error: ${result.statusCode}'));
      }
    }
  }

  Future<Either<ApiError, dynamic>> postReq(String subPath,
      {dynamic body}) async {
    final headers = _getHeaders();

    var result = await http.post(Uri.parse(baseUrl + subPath),
        body: jsonEncode(body), headers: headers);

    await Future.delayed(const Duration(seconds: 1));

    if (result.statusCode == 200 || result.statusCode == 201) {
      return Right(jsonDecode(result.body));
    } else {
      return Left(ApiError(message: 'HTTP Error: ${result.statusCode}'));
    }
  }

  Future<Either<ApiError, bool>> deleteReq(String subPath,
      {dynamic body}) async {
    final headers = _getHeaders();

    var result = await http.delete(Uri.parse(baseUrl + subPath),
        body: jsonEncode(body), headers: headers);

    if (result.statusCode == 204) {
      return const Right(true);
    } else {
      return Left(ApiError(message: 'HTTP Error: ${result.statusCode}'));
    }
  }
}