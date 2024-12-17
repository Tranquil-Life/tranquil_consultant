import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio;

import 'package:get/get.dart';
import 'package:path/path.dart';
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
  final Dio dioo = Dio();

  static const certVerifyFailed = "CERTIFICATE_VERIFY_FAILED";

  Map<String, String> _getHeaders() {
    User user = UserModel.fromJson(userDataStore.user);

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYjI1YWVmYWIwNzE3YWFiMWQwNjkzYjJkM2VjZDAxODViNjQxYzE2MjIyNWI5OTE2NjQ2NjVmZmYxN2IxM2JhNmYwZTIyNGE1OTI0MTg4YzUiLCJpYXQiOjE3MzQ0MTk4NjQuNDYyNTM2LCJuYmYiOjE3MzQ0MTk4NjQuNDYyNTM3LCJleHAiOjE3NjU5NTU4NjQuNDQ5MTE1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.WRi8vgGl2y0KPnkEr1XgmQwEBBDBiXvxMmtJ63MF3lmDbt89hLOcnao2Thvo16SLZW2T6-c_imCrTP55d0EG7fZPtHEcWfj0mgGvhD5v9hxP8KYXkPSdmjhzW-GKejvU0KKk-LneqKRI2oBJFceA04hQ4X-UEshJoXXwhm6ldbDDwsN15OTYfDkeFJSu-o7wFRiXY2yudjCqpkl-KM0BZ5ymyWwET61eKDCMsfIvAWrgPDHPVqlexAi50nXee_V-IBqYz2wXbsVp1eUsXk_UNLPNLuih-sulFMwqUnMme8DDAeqrvFxCx_stGRAe4dQXeiQi99rY7zx9iELb3tY8CD_pfJ7CJy6EC2FkZJpf8Ce5TiqKdx-SVwiuU9KUd3NT1jrkRC9WGwVirGgLdECxjIplrOdLJeZaBHR0cur2xR4bOS0jJr3fNDPLFLsBHNFX5CQ18jVFlHl1xnbaRXAL_RCpmDg2YUA5V_KuSry6NSA8tEGk2bn2C1zXl9oEsmfAAW51RQap1EgvRfvFR6mijN5T4p4Z668dF31gVxeM4y5Qn4emMjUenj9MhccKoErOH09rt_-yhgYlq2f3zEZ1VHq1wIWxee--8CfLIowduMGIa-3_k3YThBN-dtnYqfI4f1hnQJI9imllml90p0ill8rDre3m6yb87owy_ieWfss',
    };
  }

  Future<Either<ApiError, dynamic>> handleResponse(
      Either<ApiError, dynamic> eitherResponse) async {
    return eitherResponse.fold(
      (apiError) => Left(apiError),
      (data) {
        //   print('Handling data: $data');
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
      //print('Response: ${result.statusCode} - ${result.body}');

      if (result.statusCode == 200) {
        return Right(jsonDecode(result.body));
      } else {
        return Left(ApiError(message: jsonDecode(result.body)['message']));
      }
    } else {
      var result = await http.get(
          Uri.parse((exchange ? "" : baseUrl) + subPath),
          headers: headers);
      // print('Response: ${result.statusCode} - ${result.body}');

      // await Future.delayed(const Duration(seconds: 1));

      if (result.statusCode == 200) {
        return Right(jsonDecode(result.body));
      } else {
        return Left(ApiError(message: jsonDecode(result.body)['message']));
      }
    }
  }

  bool containsMultipartFile(Map<String, dynamic> data) {
    for (var value in data.values) {
      if (value is http.MultipartFile || value is List<http.MultipartFile>) {
        return true; // Found a MultipartFile
      }
    }
    return false; // No MultipartFile found
  }

  Future<Either<ApiError, dynamic>> postReq(String subPath,
      {dynamic body}) async {

    String url = baseUrl + subPath;
    final headers = _getHeaders();

    try {
      bool hasMultipartFile = containsMultipartFile(body);

      late dio.Response<dynamic> response;

      if(hasMultipartFile){
        dio.FormData form = dio.FormData.fromMap(body);

        response = await dioo.post(url,
            data: form,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${UserModel.fromJson(userDataStore.user).authToken}',
              },
            ));
      }
      else{
        response = await dioo.post(url,
            data: body,
            options: Options(headers: headers));
      }

      await Future.delayed(const Duration(seconds: 1));

      print(response);


      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);

        return Right(response.data);
      } else {

        return Left(ApiError(message: "response.data['message']"));
      }
    } on DioException catch (error) {

      print(error);

      var message = error.response?.data['message'] ?? error.message;
      return Left(ApiError(message: "message.toString()"));
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
      return Left(ApiError(message: jsonDecode(result.body)['message']));
    }
  }
}
