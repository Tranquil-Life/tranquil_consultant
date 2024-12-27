import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/auth/domain/entities/register_data.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/data/repos/user_info_repo.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  UserDataStore userDataStore = UserDataStore();
  UserInfoRepoImpl userInfoRepoImpl = UserInfoRepoImpl();
  MediaRepoImpl mediaRepo = MediaRepoImpl();

  TextEditingController emailTEC =
      // TextEditingController(text: "apple2@gmail.com");
      TextEditingController(text: "barry@gmail.com");
  // TextEditingController passwordTEC = TextEditingController(text: "password");
  TextEditingController passwordTEC = TextEditingController(text: "12345678");

  TextEditingController cvTEC = TextEditingController();
  TextEditingController identityTEC = TextEditingController();
  TextEditingController currLocationTEC = TextEditingController();
  TextEditingController areaOfExpertiseTEC = TextEditingController();
  TextEditingController yearsOfExperienceTEC = TextEditingController();
  TextEditingController languagesTEC = TextEditingController();

  TextEditingController aoeSearchController = TextEditingController();

  final dateTEC = TextEditingController();

  RegisterData params = RegisterData();

  String title = "Sign Up";
  RxBool isPasswordVisible = false.obs;

  RxBool uploading = false.obs;
  RxString fileSize = "0 KB".obs;
  String uploadType = "";
  RxString uploadUrl = "".obs;
  var loading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  var compressing = false.obs;

  var videoUrl = "".obs;
  var pictureUrl = "".obs;

  String? currentAddress;
  Position? currentPosition;

  List workStatusList = ['Self-employed', 'Employed'];

  RxList<String> languagesArr = <String>[].obs;
  RxList<String> specialtiesArr = <String>[].obs;

  var selectedType = ''.obs;

  Future signUp() async {
    Either either = await AuthRepoImpl().register(params);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) async {
      Map<String, dynamic> data = r;

      if (data['error'] == false && data['data'] != null) {
        userDataStore.user = data['data'];
      }

      AppData.isSignedIn = true;
      // User user = UserModel.fromJson(userDataStore.user);

      // print(user.toJson());

      await Get.offAllNamed(Routes.DASHBOARD);
      emailTEC.clear();
      passwordTEC.clear();
    });
  }

  Future signIn(String email, String password) async {
    loading.value = true;

    Either either = await AuthRepoImpl().signIn(email, password);

    either.fold((l) {
      return CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) async {
      Map<String, dynamic> data = r;

      if (data['error'] == false && data['data'] != null) {
        userDataStore.user = data['data']['user'];
        userDataStore.qualifications = List<Map<String, dynamic>>.from(data['data']['qualifications']);
        print("Meetings count: ${data['data']['meetings_count']}");
        print("Client count: ${data['data']['clients_count']}");

        AppData.isSignedIn = true;

        await Get.offAllNamed(Routes.DASHBOARD);

        emailTEC.clear();
        passwordTEC.clear();
      }

    });

    loading.value = false;
  }

  Future resetPassword() async {
    var either = await AuthRepoImpl().resetPassword(emailTEC.text);
    if (either.isRight()) {
      bool val = either.isRight();
      debugPrint(val.toString());
    } else {
      either.leftMap((l) => CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red));
    }
  }

  //Future<String> generateFcmToken() async {
    // var result = await AuthRepoImpl().generateFcmToken();
    // String token = "";
    // if (result.isRight()) {
    //   result.map((r) => token = r);
    //
    //   return token;
    // } else {
    //   result.leftMap((l) => CustomSnackBar.showSnackBar(
    //       context: Get.context!,
    //       title: "Error",
    //       message: l.message.toString(),
    //       backgroundColor: ColorPalette.red));
    //
    //   return "";
    // }
  //}

  // Future updateFcmToken() async {
  //   String fcmToken = await generateFcmToken();
  //
  //   if (fcmToken.isNotEmpty) {
  //     // Sends the current token to the endpoint
  //     await sendFcmTokenToDB(fcmToken);
  //   }
  // }

  // Future sendFcmTokenToDB(String fcmToken) async {
  //   var result = await AuthRepoImpl().sendFcmTokenToDB(fcmToken);
  //   if (result.isRight()) {
  //     result.map((r) => print(r.toString()));
  //   } else {
  //     result.leftMap((l) => CustomSnackBar.showSnackBar(
  //         context: Get.context!,
  //         title: "Error",
  //         message: l.message.toString(),
  //         backgroundColor: ColorPalette.red));
  //   }
  // }

  uploadCv({File? file}) async {
    var fileSize = await getFileSize(file!.path, 1);
    if (fileSize == "Too large") {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: fileMaxSize,
          backgroundColor: ColorPalette.red);
    } else {
      uploading.value = true;

      var result = await userInfoRepoImpl.uploadCv(file);

      if (result.isRight()) {
        result.map((r) {
          params.cvUrl = r;
          uploadUrl.value = params.cvUrl;
        });
      } else {
        result.leftMap((l) {
          CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red);
        });
      }
    }
  }

  uploadID({File? file}) async {
    uploading.value = true;

    var result = await userInfoRepoImpl.uploadID(file!);

    if (result.isRight()) {
      result.map((r) {
        params.identityUrl = r;
        uploadUrl.value = params.identityUrl;
      });
    } else {
      result.leftMap((l) {
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red);
      });
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

  Future<String?> uploadFile(File uploadFile, String uploadType) async {
    uploadProgress.value = 0.0;
    compressing.value = false;

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

      Reference reference = FirebaseStorage.instance.ref('$path/$fileName');
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
        videoUrl.value = downloadUrl;

        uploading.value = false;

        await Future.delayed(Duration(seconds: 1));

        Get.back();

      } else if (uploadType == profileImage) {
        pictureUrl.value = downloadUrl;

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


  clearData() {
    emailTEC.clear();
    passwordTEC.clear();
    cvTEC.clear();
    identityTEC.clear();
    dateTEC.clear();
    params.email = '';
    params.password = '';
  }

  @override
  void onClose() {
    clearData();

    super.onClose();
  }
}
