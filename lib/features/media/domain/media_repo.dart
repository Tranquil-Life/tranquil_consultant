import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class MediaRepo<T, F extends QueryParams> extends ApiService {
  Future<Either<ApiError, T>> uploadFileWithHttp(File file, String uploadType,
      [String? previousImgUrl]);

  Future<Either<ApiError, T>> uploadBytesWithHttp(
    Uint8List bytes,
    String filename,
    String uploadType, {
    required String mediaType, // e.g., "audio"
    required String mediaSubType, // e.g., "webm" | "wav" | "aac"
  });
}
