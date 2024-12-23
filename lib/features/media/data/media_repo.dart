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
        print("Video compression failed");
        return null;
      }

      return info.file;
    } catch (e) {
      print("Error compressing video: $e");
      return null;
    }
  }
}
