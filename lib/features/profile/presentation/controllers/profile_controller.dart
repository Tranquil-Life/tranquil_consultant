import 'dart:io';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/profile_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:video_player/video_player.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();
  late VideoPlayerController videoPlayerController;

  Rx<EditUser> editUser = EditUser().obs;

  dio.Dio dioObj = dio.Dio();

  ProfileRepoImpl profileRepo = ProfileRepoImpl();
  MediaRepoImpl mediaRepo = MediaRepoImpl();

  var isInitialized = false.obs; // Track if initialization is complete
  var introVideoDuration = 0.obs;

  var profilePic = UserModel.fromJson(userDataStore.user).avatarUrl.obs;
  var introVideo = UserModel.fromJson(userDataStore.user).videoIntroUrl.obs;
  RxDouble uploadProgress = 0.0.obs;
  var uploading = false.obs;
  var compressing = false.obs;
  final TextEditingController firstNameTEC = TextEditingController(
      text: UserModel.fromJson(userDataStore.user).firstName);
  final TextEditingController lastNameTEC = TextEditingController(
      text: UserModel.fromJson(userDataStore.user).lastName);
  final TextEditingController phoneTEC = TextEditingController(
      text: UserModel.fromJson(userDataStore.user).phoneNumber);
  final TextEditingController countryTEC = TextEditingController();
  final TextEditingController cityTEC = TextEditingController();
  final TextEditingController bioTEC =
      TextEditingController(text: UserModel.fromJson(userDataStore.user).bio);
  final TextEditingController timeZoneTEC = TextEditingController();
  final TextEditingController titleTEC = TextEditingController();
  final TextEditingController certificationTEC = TextEditingController();
  final TextEditingController institutionTEC = TextEditingController();
  final TextEditingController yearGraduatedTEC = TextEditingController();
  final TextEditingController modalitiesTEC = TextEditingController();

  var updatingProfile = false.obs;

  final titles = [
    'Dr',
    'LPC',
    'LMHC',
    'LCSW',
    'MFT or LMFT',
    'LBA or BCBA',
    'LPC, LMFT, LCSW',
    'Reverend, e.t.c',
    'CADC',
    'ATR or ATR-BC',
    'LPA',
    'BCC'
  ];

  var qualifications = <Map<String, dynamic>>[].obs;

  initializeVideoPlayer() async{
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(introVideo.value));
    // Wait for the controller to initialize
    await videoPlayerController.initialize();
    isInitialized.value = true;

    introVideoDuration.value = videoPlayerController.value.duration.inSeconds;
  }

  Future updateUser() async {
    updatingProfile.value = true;

    User user = User(
      firstName: firstNameTEC.text,
      lastName: lastNameTEC.text,
      phoneNumber: phoneTEC.text,
      location: "${cityTEC.text}/${countryTEC.text}",
      timezone: timeZoneTEC.text,
      bio: bioTEC.text,
    );

    var request = <String, dynamic>{};
    var qualificationReq = {'qualifications': qualifications};

    request.addAll(user.toJson());
    request.addAll(qualificationReq);

    final result = await profileRepo.updateProfile(request);

    result.fold(
      (l) => CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message!,
          backgroundColor: ColorPalette.red),
      (r) {
        editUser.value =
            EditUser(baseUser: UserModel.fromJson(r['data']['user']));
        User user = UserModel.fromJson(r['data']['user']);
        qualifications.value =
            List<Map<String, dynamic>>.from(r['data']['qualifications']);
        updateProfile(user);

        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Success",
            message: "Profile updated",
            backgroundColor: ColorPalette.green);
      },
    );

    updatingProfile.value = false;
  }

  void updateProfile(User user) {
    userDataStore.user['avatar_url'] = user.avatarUrl;
    userDataStore.user['f_name'] = user.firstName;
    userDataStore.user['l_name'] = user.lastName;
    userDataStore.user['phone'] = user.phoneNumber;
    userDataStore.user['birth_date'] = user.birthDate;
    userDataStore.user['gender'] = user.gender;
    userDataStore.user['staff_id'] = user.staffId;
    userDataStore.user['company_name'] = user.companyName;
    userDataStore.user['bio'] = user.bio;
    // userDataStore.user['is_verified'] = user.isVerified;

    userDataStore.user = userDataStore.user;
  }

  restoreUser() {
    editUser.value = EditUser(baseUser: UserModel.fromJson(userDataStore.user));
  }

  // getContinent(placemarks) async {
  //   Either either = await profileRepo.currentContinent();
  //
  //   var continent = "";
  //
  //   either.fold((l) {
  //     if (l.message.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
  //       CustomSnackBar.showSnackBar(
  //           context: Get.context!,
  //           title: "Internet Error",
  //           message: "Change your internet provider",
  //           backgroundColor: ColorPalette.red);
  //     } else {
  //       CustomSnackBar.showSnackBar(
  //           context: Get.context!,
  //           title: "Error",
  //           message: l.message,
  //           backgroundColor: ColorPalette.red);
  //     }
  //   }, (r) {
  //     final jsonData = r;
  //
  //     final countries = jsonData;
  //
  //     for (var country in countries) {
  //       if (country['country'] == placemarks.first.country) {
  //         continent = country['continent'];
  //         break;
  //       }
  //     }
  //   });
  //
  //   return continent;
  // }

  getMyLocationInfo() async {
    var result = await getCurrLocation();
    List<Placemark> placemarks = result['placemarks'];
    String country = placemarks.first.country!;
    String state = placemarks.first.administrativeArea!;
    int timezoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timezoneOffset / hourInMilliSecs;

    countryTEC.text = country;
    cityTEC.text = state;
    timeZoneTEC.text = "$formattedTimeZone";
  }

  // Future uploadVideo(File file) async{
  //   dio.FormData formData = dio.FormData.fromMap({
  //     "upload_preset": "",  // Ensure you have this correctly set
  //     "file": await dio.MultipartFile.fromFile(file.path, filename: basename(file.path)),
  //   });
  //
  //   dio.Response response = await dio.Dio().post(
  //     'https://api.cloudinary.com/v1_1/tranquil-life/upload',
  //     data: formData,
  //     options: dio.Options(
  //       headers: {
  //         'Content-Type': 'multipart/form-data',
  //         'Authorization': 'Bearer ',  // Make sure to use the updated token
  //       },
  //     ),
  //   );
  //
  //   print(response.data);
  //
  // }

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

    print('File size before compression: $fileSizeInMB MB');

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

        //TODO: Compress images
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

      if(uploadType == videoIntro){
        introVideo.value = downloadUrl;

        await Future.delayed(Duration(seconds: 1));

        Get.back();

        await initializeVideoPlayer();
      }

      // Return the download URL
      return downloadUrl;

    } catch (e) {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: "Error uploading file: $e",
          backgroundColor: ColorPalette.red);

      return null; // Return null if there's an error
    }
  }

// Future uploadVideo(File file) async{
//   final int fileSizeInBytes = await file.length();
//   final double fileSizeInKB = fileSizeInBytes / 1024;
//   final double fileSizeInMB = fileSizeInKB / 1024;
//
//   print('File size: $fileSizeInBytes bytes');
//   print('File size: $fileSizeInKB KB');
//   print('File size: $fileSizeInMB MB');
//
//     // Prepare data for the file upload
//     final String field = "file"; // Ensure this matches the API's expected field name.
//
//     // Create FormData from the file
//     dio.FormData formData = dio.FormData.fromMap({
//       "upload_type": "video_intro", // Other fields as necessary
//       field: await dio.MultipartFile.fromFile(file.path, filename: basename(file.path)),
//     });
//
//     // Set the headers if needed (e.g., authorization)
//     Options options = Options(
//       headers: {
//         'Authorization': 'Bearer ${UserModel.fromJson(userDataStore.user).authToken}', // Replace with your auth token if necessary
//         'Accept': 'application/json',
//         'Content-Type': 'multipart/form-data',
//       },
//     );
//
//     final response = await dioObj.post(
//       baseUrl+MediaEndpoints.uploadFile, // Replace with your actual API endpoint
//       data: formData,
//       options: options,
//     );
//
//     // Handle the response
//     if (response.statusCode == 200) {
//       print("Upload successful: ${response.data}");
//     } else {
//       print("Error uploading: ${response.statusCode}");
//     }
// }
}
