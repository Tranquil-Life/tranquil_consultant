import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/features/media/domain/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:video_compress/video_compress.dart';

class MediaRepoImpl extends MediaRepo {
  // Compress the video file
  Future<File?> compressVideo(File file) async {
    try {
      final MediaInfo? info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      if (info == null || info.file == null) {
        CustomSnackBar.errorSnackBar("Oops, video compression failed!");
        return null;
      }

      return info.file;
    } catch (e) {
      print("Error compressing video: $e");
      return null;
    }
  }

  @override
  Future<Either<ApiError, dynamic>> uploadFileWithHttp(
      File file, String uploadType,
      [String? previousImgUrl]) async {
    User therapist = UserModel.fromJson(userDataStore.user);

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
      /// MultiPart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl + MediaEndpoints.uploadFile),
      );
      Map<String, String> headers = {
        "Authorization": "Bearer ${therapist.authToken}",
        "Content-type": "multipart/form-data"
      };
      request.files.add(
        http.MultipartFile(
          'file',
          file.openRead(), // Use openRead() to stream the file
          await file.length(), // Use await to get the file length
          filename: p.basename(file.path),
          contentType: MediaType(mediaType, mediaSubType),
        ),
      );
      request.headers.addAll(headers);
      request.fields.addAll({
        "upload_type": uploadType,
      });

      // Setting a timeout duration
      var res = await request
          .send()
          .timeout(Duration(minutes: 5)); // Increase timeout duration

      var newRes = await http.Response.fromStream(res);
      var data = jsonDecode(newRes.body);

      if (newRes.statusCode == 200) {
        return Right(data);
      } else {
        return Left(
            ApiError(message: data['message'] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      return Left(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> uploadBytesWithHttp(
      Uint8List bytes, String filename, String uploadType,
      {required String mediaType, required String mediaSubType}) async {
    final therapist = UserModel.fromJson(userDataStore.user);

    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl + MediaEndpoints.uploadFile),
      );

      req.headers.addAll({
        "Authorization": "Bearer ${therapist.authToken}",
        "Content-Type": "multipart/form-data",
      });

      req.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType(mediaType, mediaSubType),
      ));

      req.fields['upload_type'] = uploadType;

      final res = await req.send().timeout(const Duration(minutes: 5));
      final newRes = await http.Response.fromStream(res);
      final data = jsonDecode(newRes.body);

      if (newRes.statusCode == 200) {
        return Right(data);
      } else {
        return Left(
            ApiError(message: data['message'] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      return Left(ApiError(message: e.toString()));
    }
  }
}
