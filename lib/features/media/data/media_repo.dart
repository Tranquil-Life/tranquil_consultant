import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/media/domain/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class MediaRepoImpl extends MediaRepo {
  @override
  Future<Either<ApiError, dynamic>> uploadFileWithHttp(
      File file, String uploadType,
      [String? previousImgUrl]) async {
    User client = UserModel.fromJson(userDataStore.user);

    String mediaType = "";
    String mediaSubType = "";

    switch (uploadType) {
      case profileImage:
        mediaType = "image";
        mediaSubType = "png";
        break;
      case voiceNote:
        mediaType = "audio";
        mediaSubType = "wav";
        break;
    }

    try {
      ///MultiPart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl + MediaEndpoints.uploadFile),
      );
      Map<String, String> headers = {
        "Authorization": "Bearer ${client.authToken}",
        "Content-type": "multipart/form-data"
      };
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: p.basename(file.path),
          contentType: MediaType(mediaType, mediaSubType),
        ),
      );
      request.headers.addAll(headers);
      request.fields.addAll({
        "upload_type": uploadType,
      });
      var res = await request.send();
      //return res.statusCode;

      var newRes = await http.Response.fromStream(res);
      var data = jsonDecode(newRes.body);

      return Right(data);
    } catch (e) {
      return Left(ApiError(message: e.toString()));
    }
  }
}
