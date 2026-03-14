import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

abstract class MediaService {
  static final _filePicker = FilePicker.platform;
  static final _imagePicker = ImagePicker();
  static final _imageCropper = ImageCropper();

  static bool isSupportedWebImage(XFile file) {
    final name = file.name.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png') ||
        name.endsWith('.webp');
  }

  static Future<XFile?> openCamera([
    ImageSource source = ImageSource.camera,
  ]) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
      maxHeight: 720,
      maxWidth: 720,
    );

    if (pickedFile == null) return null;

    if (kIsWeb && !isSupportedWebImage(pickedFile)) {
      Get.snackbar(
        "Unsupported format",
        "Please upload a JPG or PNG image on web.",
      );
      return null;
    }

    if (kIsWeb) {
      return pickedFile;
    }

    try {
      final XFile? cropped = await _cropImage(pickedFile);
      return cropped ?? pickedFile;
    } catch (e) {
      debugPrint('Crop failed: $e');
      return pickedFile;
    }
  }

  static Future<XFile?> selectImage([
    ImageSource source = ImageSource.gallery,
  ]) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
      maxHeight: 720,
      maxWidth: 720,
    );

    if (pickedFile == null) return null;

    // If you use a cropper, it must support XFile or return one.
    // For now, let's return the pickedFile directly to fix the crash.
    return pickedFile;
  }

  static Future<XFile?> selectAudio() => _selectFile(type: FileType.audio);

  static Future<XFile?> selectDocument(
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

  static Future<XFile?> _selectFile({
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
      // AuthController.instance.uploadCv(file: File(result.files.first.path!));
    }

    return XFile(result.files.first.path!);
  }

  static Future<XFile?> _cropImage(XFile xFile) async {
    if (kIsWeb) {
      // image_cropper 5.x+ has basic web support, but it requires a
      // different setup. If not configured, just return the original.
      return xFile;
    }

    // On Mobile, we can safely use the File path
    var croppedFile = await _imageCropper.cropImage(
        sourcePath: xFile.path, compressQuality: 75);

    if (croppedFile == null) return null;

    // Convert CroppedFile back to XFile for the rest of your app
    return XFile(croppedFile.path);
  }
}
