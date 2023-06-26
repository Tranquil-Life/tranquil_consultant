import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/profile/domain/repos/user_info_repo.dart';
import 'package:http/http.dart' as http;


class UserInfoRepoImpl extends UserInfoRepo{
  @override
  Future<Either<ApiError, dynamic>> updateInfo(String filePath) {
    // TODO: implement updateInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> uploadCv(
      File file) async{
    try{
      var stream  = http.ByteStream(file.openRead());
      stream.cast();

      var uri = Uri.parse(baseUrl+MediaEndpoints.uploadFile);

      var request = http.MultipartRequest('POST', uri);

      request.fields['username'] = "${AuthController.instance.params.firstName}_${AuthController.instance.params.lastName}" ;
      request.fields['upload_type'] = "cv" ;

      var multiport = http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: p.basename(file.path),
        contentType: MediaType('application', 'x-tar'),
      );

      request.files.add(multiport);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode == 200){
        return Right(jsonDecode(response.body)['storage_url']);
      }else {
        return Left(ApiError(message: jsonDecode(response.body)['message'].toString()));
      }
    }
    on SocketException catch(e) {
      return Left(ApiError(
          message: e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> uploadID(File file) async{
    try{
      var request = http.MultipartRequest('POST',
          Uri.parse(baseUrl+MediaEndpoints.uploadFile));

      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: p.basename(file.path),
          contentType: MediaType('application', 'x-tar'),
        ),
      );

      Map<String,String> headers={
        "Content-type": "multipart/form-data"
      };

      request.headers.addAll(headers);

      request.fields.addAll({
        "username": "${AuthController.instance.params.firstName}_${AuthController.instance.params.lastName}",
        "upload_type": "photo_id",
      });

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode == 200){
        return Right(jsonDecode(response.body)['storage_url']);
      }else{
        return Left(ApiError(
            message: jsonDecode(response.body)['message'].toString()));
      }
    }
    on SocketException catch(e) {
      return Left(ApiError(
          message: e.toString()));
    }
  }

}