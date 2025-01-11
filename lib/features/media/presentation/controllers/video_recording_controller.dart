import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:video_player/video_player.dart';

class VideoRecordingController extends GetxController{

  MediaRepoImpl mediaRepo = MediaRepoImpl();

  RxDouble uploadProgress = 0.0.obs;
  var uploading = false.obs;
  var compressing = false.obs;

  late VideoPlayerController videoPlayerController;


  initializeVideoPlayer(ProfileController profileController) async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(profileController.introVideo.value!));
    // Wait for the controller to initialize
    await videoPlayerController.initialize();

    profileController.introVideoDuration.value = videoPlayerController.value.duration.inSeconds;
  }

  Future<String?> uploadFile(File uploadFile, String uploadType, dynamic controller) async {
    User user = UserModel.fromJson(userDataStore.user);

    resetUploadVars();

    final int fileSizeInBytes = await uploadFile.length();
    final double fileSizeInKB = fileSizeInBytes / 1024;
    final double fileSizeInMB = fileSizeInKB / 1024;

    try {
      // Define the storage path and image name
      String path = uploadType; // Example directory in Firebase Storage
      String fileName =
          "${uploadFile.path.split('/').last}_${DateTime.now().millisecondsSinceEpoch}"; // Example image name

      // Compress the file if it's an image
      File? compressedFile;

      if (uploadFile.path.endsWith('.jpg') ||
          uploadFile.path.endsWith('.jpeg') ||
          uploadFile.path.endsWith('.png')) {
        //TODO: Compress image
        compressedFile = uploadFile;
      } else if (uploadFile.path.endsWith('.mp4') ||
          uploadFile.path.endsWith('.mov') ||
          uploadFile.path.endsWith('.avi')) {
        compressing.value = true;
        // Compress video
        compressedFile = await mediaRepo.compressVideo(uploadFile);
      } else {
        // If not an image or video, skip compression
        compressedFile = uploadFile;
      }

      if (compressedFile == null) {
        print("Error compressing file");
        return null;
      } else {
        final int afterCompressionSizeInBytes = await compressedFile.length();
        final double afterCompressionSizeInKB =
            afterCompressionSizeInBytes / 1024;
        final double afterCompressionSizeInMB = afterCompressionSizeInKB / 1024;

        // print('File size after compression: $afterCompressionSizeInMB MB');
      }

      compressing.value = false;

      uploading.value = true;

      // Get the system temp directory to save the file
      final Directory systemTempDir = Directory.systemTemp;

      // Load the image data from the assets
      final byteData = await rootBundle.load(
          compressedFile.path); // Assuming `imgFile.path` is the image path

      // Create a new file from the temp directory with a unique name
      final file =
      File('${systemTempDir.path}/$fileName${getExtension(uploadType)}');

      // Write the byte data into the file
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      Reference reference = FirebaseStorage.instance.ref('$path/${user.id}_${fileName.substring(0, 8)}');
      // Start the file upload and listen to the progress
      UploadTask uploadTask = reference.putFile(file);

      // Monitor the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Calculate progress percentage
        uploadProgress.value =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      });

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      if (uploadType == videoIntro) {
        controller.introVideo.value = downloadUrl;

        uploading.value = false;

        await Future.delayed(Duration(seconds: 1));

        Get.back();

        await initializeVideoPlayer(controller);
      }
      else if (uploadType == profileImage) {
        controller.profilePic.value = downloadUrl;

        uploading.value = false;

        await Future.delayed(Duration(seconds: 1));

        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Success",
            message: "Upload successful",
            backgroundColor: ColorPalette.green);
      }

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: "Error uploading file: $e",
          backgroundColor: ColorPalette.red);

      return null;
    }
  }

  getExtension(String uploadType) {
    switch (uploadType) {
      case profileImage:
        return '.png';
      case voiceNote:
        return '.wav';
      case videoIntro:
        return '.mp4';
    }
  }

  resetUploadVars(){
    uploadProgress.value = 0.0;
    uploading.value = false;
    compressing.value = false;
  }
}