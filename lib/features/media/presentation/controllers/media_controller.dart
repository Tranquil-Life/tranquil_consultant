import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:tl_consultant/core/data/store.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/auth/data/repos/reg_data_store.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/features/media/presentation/screens/web_video_recording_page.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:tl_consultant/core/utils/html_stub.dart'
if (dart.library.html) 'dart:html' as html;

class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  MediaRepoImpl mediaRepo = MediaRepoImpl();

  webrtc.MediaStream? stream;
  webrtc.MediaRecorder? recorder;
  final List<Uint8List> chunks = [];

  RxDouble uploadProgress = 0.0.obs;
  var uploading = false.obs;
  var compressing = false.obs;
  var previousUrl = ''.obs;

  late VideoPlayerController videoPlayerController;

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(DashboardController.instance.videoIntro.value));
    // Wait for the controller to initialize
    await videoPlayerController.initialize();

    ProfileController.instance.introVideoDuration.value =
        videoPlayerController.value.duration.inSeconds;
  }

  Future<String?> uploadFile(
      XFile uploadFile, String uploadType, dynamic controller) async {

    //Error uploading: PlatformException(MEDIA_ERR_SRC_NOT_SUPPORTED, MEDIA_ELEMENT_ERROR: Empty src attribute, The video has been found to be unsuitable (missing or in a format not supported by your browser)., null)

    debugPrint("Before uploading: ${uploadFile.path}, size: ${await uploadFile.length()} bytes");
    User user = UserModel.fromJson(userDataStore.user);

    if (uploadType == videoIntro) {
      previousUrl.value = user.videoIntroUrl!;
    } else if (uploadType == profileImage) {
      previousUrl.value = user.avatarUrl;
    }

    resetUploadVars();

    // 1. Get file size platform-agnostically
    final int fileSizeInBytes = await uploadFile.length();
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    try {
      // Define the storage path and image name
      String path = uploadType; // Example directory in Firebase Storage
      String fileName =
          "${uploadFile.path.split('/').last}_${DateTime.now().millisecondsSinceEpoch}"; // Example image name

      // Compress the file if it's an image
      // File? compressedFile;

      // 2. Handle Compression (Skip video compression on Web for now)
      dynamic fileToUpload;

      if (kIsWeb) {
        fileToUpload = uploadFile;
      } else {
        // Mobile: Keep your existing compression logic
        if (uploadFile.path.endsWith('.jpg') ||
            uploadFile.path.endsWith('.jpeg') ||
            uploadFile.path.endsWith('.png')) {
          fileToUpload = uploadFile;
        } else if (uploadFile.path.endsWith('.mp4') ||
            uploadFile.path.endsWith('.mov') ||
            uploadFile.path.endsWith('.avi')) {
          compressing.value = true;
          // You might need to adjust your mediaRepo to accept XFile or use File(uploadFile.path)
          fileToUpload = await mediaRepo.compressVideo(File(uploadFile.path));

          // if (fileToUpload == null) {
          //   print("Error compressing file");
          //   return null;
          // } else {
          //   final int afterCompressionSizeInBytes = await fileToUpload.length();
          //   final double afterCompressionSizeInKB =
          //       afterCompressionSizeInBytes / 1024;
          //   final double afterCompressionSizeInMB = afterCompressionSizeInKB / 1024;
          //
          //   // print('File size after compression: $afterCompressionSizeInMB MB');
          // }

          compressing.value = false;
        } else {
          fileToUpload = uploadFile;
        }
      }

      uploading.value = true;

      // 3. Web-Safe Firebase Upload
      Reference reference =
          FirebaseStorage.instance.ref('$path/${user.id}_$fileName');
      UploadTask uploadTask;

      if (kIsWeb) {
        Uint8List fileBytes = await uploadFile.readAsBytes();

        debugPrint("File bytes length: ${fileBytes.lengthInBytes}, size: ${fileBytes.lengthInBytes / (1024 * 1024)} MB");

        SettableMetadata metadata = SettableMetadata(contentType: 'video/mp4');
        uploadTask = reference.putData(fileBytes, metadata);
      } else {
        File file =
            fileToUpload is XFile ? File(fileToUpload.path) : fileToUpload;
        uploadTask = reference.putFile(file);
      }

      // Monitor progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      debugPrint("Download URL: $downloadUrl");

      if (uploadType == videoIntro) {
        controller.introVideo.value = downloadUrl;
        userDataStore.user[videoIntro] = downloadUrl;
        registrationDataStore.setField(videoIntro, downloadUrl);

        uploading.value = false;

        await Future.delayed(Duration(seconds: 1));

        Get.back();

        //locate and delete previous recording from storage before uploading new one
        if(!kIsWeb) deleteFileFromUrl(previousUrl.value);

        await initializeVideoPlayer();
      } else if (uploadType == profileImage) {
        controller.profilePic.value = downloadUrl;
        userDataStore.user[avatarUrl] = downloadUrl;

        registrationDataStore.setField(avatarUrl, downloadUrl);

        uploading.value = false;

        await Future.delayed(Duration(seconds: 1));

        deleteFileFromUrl(previousUrl.value);

        CustomSnackBar.successSnackBar(body: "Upload successful");
      }

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      debugPrint("Error uploading: $e");
      // CustomSnackBar.errorSnackBar("Error uploading file: $e");
      return null;
    }
  }

  String getExtension(String uploadType) {
    switch (uploadType) {
      case profileImage:
        return '.png';
      case voiceNote:
        return '.wav';
      case videoIntro:
        return '.mp4';
      default:
        return '';
    }
  }

  Future<void> deleteFileFromUrl(String fileUrl) async {
    try {
      // Extract the path from the URL
      String decodedUrl = Uri.decodeFull(fileUrl.split('?')[0]);
      String firebasePath = decodedUrl.split('/o/')[1];

      // Delete the file from Firebase Storage
      await FirebaseStorage.instance.ref().child(firebasePath).delete();

      print("File deleted successfully.");
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  /// Picks an image (web) and uploads to Firebase Storage.
  /// Returns the download URL.
  static Future<Uint8List?> pickImageBytesWeb() async {
    if (!kIsWeb) {
      // Return null or throw an error if this is called on Mobile
      return null;
    }

    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;

    final file = uploadInput.files?.first;

    if (file == null) return null;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;

    print("FILE: ${reader.onLoadEnd.first}");

    return reader.result as Uint8List;
  }

  static Future<String?> uploadImage({
    required Uint8List bytes,
    required String folder,
    String extension = 'jpg',
  }) async {
    final user = UserModel.fromJson(userDataStore.user);
    final fileName =
        "${user.id}_${DateTime.now().millisecondsSinceEpoch}.$extension";

    print("file name: $fileName");

    final ref = FirebaseStorage.instance.ref('$folder/$fileName');

    print("reference: $ref");

    final task = ref.putData(
      bytes,
      SettableMetadata(contentType: "image/jpeg"),
    );

    final snap = await task;

    print("Upload state: ${snap.state}"); // should be TaskState.success

    final downloadUrl = await ref.getDownloadURL();
    print("download url: $downloadUrl");
    return downloadUrl;
  }

  // Inside your main page's button or function
  void recordAndDownload(BuildContext context) async {
    // 1. Capture the navigator before the async gap
    final navigator = Navigator.of(context);

    final Uint8List? videoBytes = await navigator.push(
      MaterialPageRoute(
        builder: (_) =>
            const WebVideoRecordingPage(maxDuration: Duration(seconds: 60)),
      ),
    );

    // 2. IMPORTANT: Check if the user navigated away while recording
    if (!context.mounted) return;

    if (videoBytes != null && videoBytes.isNotEmpty) {
      // Reset progress
      uploadProgress.value = 0.0;

      User user = UserModel.fromJson(userDataStore.user);
      String path = videoIntro;
      String fileName =
          "intro_video_${DateTime.now().millisecondsSinceEpoch}.webm";
      Reference reference =
          FirebaseStorage.instance.ref('$path/${user.id}_$fileName');

      // 3. Start the upload task
      UploadTask uploadTask = reference.putData(
        videoBytes,
        SettableMetadata(contentType: "video/webm"),
      );

      // Monitor progress
      final progressSubscription =
          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      });

      // 4. Show the dialog
      // Use a try-finally block to ensure the dialog closes even if the upload fails
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Uploading Video Intro'),
            content: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: uploadProgress.value / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        '${uploadProgress.value.toStringAsFixed(2)}% uploaded'),
                  ],
                )),
          );
        },
      );

      try {
        // 5. Wait for the upload to complete
        TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // 6. Update data
        DashboardController.instance.videoIntro.value = downloadUrl;
        userDataStore.user[videoIntro] = downloadUrl;
      } catch (e) {
        debugPrint("Upload failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload failed. Please try again.")),
        );
      } finally {
        // 7. ALWAYS close the dialog and cancel listener
        progressSubscription.cancel();
        if (context.mounted) {
          // This pops the dialog specifically
          navigator.pop();
        }
      }
      DashboardController.instance.restoreUserInfo();
      //GPT I want to get the new duration
      await initializeVideoPlayer();
    }
  }

  // Future<void> startVideoRecording() async {
  //   chunks.clear();
  //
  //   stream = await webrtc.navigator.mediaDevices.getUserMedia({
  //     'audio': true,
  //     'video': {'facingMode': 'user'},
  //   });
  //
  //   recorder = webrtc.MediaRecorder();
  //   recorder!.startWeb(
  //     stream!,
  //     mimeType: 'video/webm', // keep simple; vp8/vp9 may fail on some browsers
  //     timeSlice: 1000, // chunk every 1s
  //     onDataChunk: (dynamic data, bool isLast) {
  //       final bytes = _toBytes(data);
  //       if (bytes != null && bytes.isNotEmpty) chunks.add(bytes);
  //       return null;
  //     },
  //   );
  // }
  //
  // Uint8List? _toBytes(dynamic data) {
  //   if (data is Uint8List) return data;
  //   if (data is List<int>) return Uint8List.fromList(data);
  //   return null;
  // }
  //
  // Future<Uint8List> stopVideoRecording() async {
  //   await recorder?.stop();
  //   stream?.getTracks().forEach((t) => t.stop());
  //
  //   final total = chunks.fold<int>(0, (s, b) => s + b.length);
  //   final out = Uint8List(total);
  //   var offset = 0;
  //   for (final c in chunks) {
  //     out.setRange(offset, offset + c.length, c);
  //     offset += c.length;
  //   }
  //   return out;
  // }

  void resetUploadVars() {
    uploadProgress.value = 0.0;
    uploading.value = false;
    compressing.value = false;
  }

  void clearData() {
    uploadProgress.value = 0.0;
    uploading.value = false;
    compressing.value = false;
  }
}
