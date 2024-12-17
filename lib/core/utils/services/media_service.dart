import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

abstract class MediaService {
  static final _filePicker = FilePicker.platform;
  static final _imagePicker = ImagePicker();
  static final _imageCropper = ImageCropper();

  static Future<File?> openCamera([
    ImageSource source = ImageSource.camera,
  ]) async {
    final XFile? capturedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
      maxHeight: 720,
      maxWidth: 720,
    );
    if (capturedFile == null) return null;
    return _cropImage(File(capturedFile.path));
  }

  static Future<File?> selectImage([
    ImageSource source = ImageSource.gallery,
  ]) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
      maxHeight: 720,
      maxWidth: 720,
    );
    if (pickedFile == null) return null;
    return _cropImage(File(pickedFile.path));
  }

  static Future<File?> selectAudio() => _selectFile(type: FileType.audio);

  static Future<File?> selectDocument(
          {List<String>? allowedExtensions, String? uploadTpe}) =>
      _selectFile(
          type: FileType.any,
          allowedExtensions: allowedExtensions,
          uploadType: uploadTpe);

  ///Returns a jpg image file
  // static Future<File?> generateVideoThumb(
  //     String path, {
  //       bool fromFile = false,
  //       int? maxHeight,
  //     }) async {
  //   if (fromFile) {
  //     final data = await VideoThumbnail.thumbnailData(
  //       maxHeight: chatBoxMaxWidth!.round(),
  //       imageFormat: ImageFormat.JPEG,
  //       quality: 75,
  //       video: path,
  //     );
  //     if (data == null) return null;
  //     return File.fromRawPath(data);
  //   }
  //   final data = await VideoThumbnail.thumbnailFile(
  //     maxHeight: maxHeight ?? chatBoxMaxWidth!.round(),
  //     imageFormat: ImageFormat.JPEG,
  //     quality: 75,
  //     video: path,
  //   );
  //   if (data == null) return null;
  //   return File(data);
  // }

  static Future<File?> _selectFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    String? uploadType,
  }) async {
    FilePickerResult? result = await _filePicker.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );
    if (result == null) return null;

    if (uploadType == "cv") {
      AuthController.instance.uploadCv(file: File(result.files.first.path!));
    }

    return File(result.files.first.path!);
  }

  static Future<File?> _cropImage(File file) async {
    var croppedFile = await _imageCropper.cropImage(
        sourcePath: file.path, compressQuality: 75);
    if (croppedFile == null) return null;

    //TODO: UNcomment
    // AuthController.instance.uploadID(file: File(croppedFile.path));
    return File(croppedFile.path);
  }
}
