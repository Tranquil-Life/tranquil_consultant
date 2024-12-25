

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ApiData {
  final int? statusCode;
  final dynamic data;

  const ApiData(this.data, this.statusCode);
}

class ApiService {
  final Dio dio = Dio();

  static const certVerifyFailed = "CERTIFICATE_VERIFY_FAILED";

  Map<String, String> _getHeaders() {
    User user = UserModel.fromJson(userDataStore.user);

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user.authToken}',
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
    } on DioException catch (e) {
      // Handle Dio errors explicitly
      if (e.response != null) {
        // print("Dio Error Response: ${e.response!.data}");
        return Left(ApiError(
            message: e.response!.data['message'] ??
                e.response!.statusMessage ??
                "Unknown error"));
      } else {
        // print("Dio Error: ${e.message}");
        return Left(ApiError(message: e.message));
      }
    } catch (e) {
      // Handle other exceptions
      // print("Unexpected Error: $e");
      return Left(ApiError(message: "Unexpected error occurred"));
    }
  }

  Future<Either<ApiError, dynamic>> postReq(String subPath,
      {dynamic body}) async {
    String url = baseUrl + subPath;
    final headers = _getHeaders();
    Response<dynamic> response;

    bool hasMultipartFile = containsMultipartFile(body);

    if (hasMultipartFile) {
      FormData form = FormData.fromMap(body);

      response = await dio.post(
        url,
        data: form,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${UserModel.fromJson(userDataStore.user).authToken}',
          },
        ),
      );
    } else {
      response = await dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return Right(response.data);
    } else {
      // Log and return error if status code is not as expected
      print("ERROR: ${response.data}");
      return Left(
          ApiError(message: response.data['message'] ?? "Unknown error"));
    }
  }

  Future<Either<ApiError, dynamic>> getReq(String subPath,
      [bool exchange = false, bool countries = false]) async {
    final headers = _getHeaders();
    String url = (exchange ? "" : baseUrl) + subPath;

    if (countries) {
      var response = await dio.get(subPath);
      //print('Response: ${result.statusCode} - ${result.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return Right(response.data);
      } else {
        // Log and return error if status code is not as expected
        print("ERROR: ${response.data}");
        return Left(
            ApiError(message: response.data['message'] ?? "Unknown error"));
      }
    } else {
      var response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return Right(response.data);
      } else {
        // Log and return error if status code is not as expected
        print("ERROR: ${response.data}");
        return Left(
            ApiError(message: response.data['message'] ?? "Unknown error"));
      }
    }
  }

  Future<Either<ApiError, bool>> deleteReq(String subPath,
      {dynamic body}) async {
    final headers = _getHeaders();
    String url = baseUrl + subPath;

    var response =
        await dio.delete(url, data: body, options: Options(headers: headers));

    if (response.statusCode == 204) {
      return const Right(true);
    } else {
      return Left(
          ApiError(message: response.data['message'] ?? "Unknown error"));
    }
  }

  bool containsMultipartFile(Map<String, dynamic> data) {
    for (var value in data.values) {
      if (value is MultipartFile || value is List<MultipartFile>) {
        return true; // Found a MultipartFile
      }
    }
    return false; // No MultipartFile found
  }
}
