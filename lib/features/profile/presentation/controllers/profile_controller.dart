import 'dart:io';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/profile_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/domain/entities/qualification.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:video_player/video_player.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();
  late VideoPlayerController videoPlayerController;

  Rx<EditUser> editUser = EditUser().obs;

  dio.Dio dioObj = dio.Dio();

  ProfileRepoImpl profileRepo = ProfileRepoImpl();
  MediaRepoImpl mediaRepo = MediaRepoImpl();

  var introVideoDuration = 0.obs;

  var profilePic = UserModel.fromJson(userDataStore.user).avatarUrl.obs;
  var introVideo = UserModel.fromJson(userDataStore.user).videoIntroUrl.obs;
  var meetingsCount = UserModel.fromJson(userDataStore.user).totalMeetings;
  var clientsCount = UserModel.fromJson(userDataStore.user).totalClients;
  RxDouble uploadProgress = 0.0.obs;
  var uploading = false.obs;
  var compressing = false.obs;
  var deletingId =
      Rxn<int?>(); // Use null to indicate no qualification is being deleted

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
  final TextEditingController certificationTEC = TextEditingController();
  final TextEditingController institutionTEC = TextEditingController();
  final TextEditingController yearGraduatedTEC = TextEditingController();
  final TextEditingController modalitiesTEC = TextEditingController();

  var updatingProfile = false.obs;

  var qualifications = <Qualification>[].obs;
  RxList modalities = UserModel.fromJson(userDataStore.user).specialties!.obs;
  RxList titles = [].obs;
  var topics = [].obs;

  initializeVideoPlayer() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(introVideo.value!));
    // Wait for the controller to initialize
    await videoPlayerController.initialize();

    introVideoDuration.value = videoPlayerController.value.duration.inSeconds;
  }

  List<Qualification> getQualifications() {
    qualifications.clear();

    int lastId = userDataStore.qualifications
        .where((item) => item.containsKey('id'))
        .fold<int>(
            0,
            (previousValue, item) =>
                item['id'] > previousValue ? item['id'] as int : previousValue);

    for (var item in userDataStore.qualifications) {
      if (!item.containsKey('id') || item['id'] == null) {
        lastId += 1; // Increment lastId for new entries
        item['id'] = lastId;
      }

      qualifications.add(Qualification.fromJson(item));
    }

    return qualifications;
  }

  containsTitle(String lastName) {
    bool exists = false;
    for (var e in titleOptions) {
      if (lastName.contains(e)) {
        exists = true;
      }
    }

    if (exists) {
      lastNameTEC.text = lastName.split(',').first;
    }
  }

  Future updateUser() async {
    updatingProfile.value = true;
    containsTitle(lastNameTEC.text);

    User user = User(
        firstName: firstNameTEC.text,
        lastName: titles.isEmpty
            ? lastNameTEC.text
            : "${lastNameTEC.text}, ${titles.join(', ')}",
        avatarUrl: profilePic.value,
        phoneNumber: phoneTEC.text,
        location: "${cityTEC.text}/${countryTEC.text}",
        timezone: timeZoneTEC.text,
        bio: bioTEC.text,
        videoIntroUrl: introVideo.value,
        specialties: modalities);

    var request = <String, dynamic>{};
    var qualificationReq = {'qualifications': userDataStore.qualifications};

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
        print(r);
        editUser.value = EditUser(baseUser: UserModel.fromJson(r['user']));
        User user = UserModel.fromJson(r['user']);
        var qualifications = r['qualifications'] ?? [];

        updateProfile(user, qualifications);

        return CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Success",
            message: "Profile updated",
            backgroundColor: ColorPalette.green);
      },
    );

    updatingProfile.value = false;
  }

  void updateProfile(User user, List qualifications) {
    userDataStore.user['avatar_url'] = user.avatarUrl;
    userDataStore.user['f_name'] = user.firstName;
    userDataStore.user['l_name'] = user.lastName;
    userDataStore.user['phone'] = user.phoneNumber;
    userDataStore.user['birth_date'] = user.birthDate;
    userDataStore.user['gender'] = user.gender;
    userDataStore.user['staff_id'] = user.staffId;
    userDataStore.user['company_name'] = user.companyName;
    userDataStore.user['bio'] = user.bio;
    userDataStore.user['video_intro'] = user.videoIntroUrl!;
    userDataStore.user['specialties'] = user.specialties;
    // userDataStore.user['is_verified'] = user.isVerified;

    userDataStore.user = userDataStore.user;
    if (qualifications.isEmpty) {
      userDataStore.qualifications =
          List<Map<String, dynamic>>.from(qualifications);
    }
  }

  restoreUser() {
    editUser.value = EditUser(baseUser: UserModel.fromJson(userDataStore.user));
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

  void deleteQualification(int? id, int index) async {
    deletingId.value = id!; // Set the current deleting ID
    Future.delayed(Duration(seconds: 2), () {
      //remove from the userDataStore
      userDataStore.qualifications.removeAt(index);
      //remove from the DB
      deleteQualificationFromDB(id);

      deletingId.value = null; // Reset after deletion

      getQualifications();
    });
  }

  Future deleteQualificationFromDB(int id) async {
    Either either = await profileRepo.deleteQualification(id);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message!,
            backgroundColor: ColorPalette.red), (r) {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Success",
          message: "Qualification deleted",
          backgroundColor: ColorPalette.green);
    });
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
        introVideo.value = downloadUrl;

        uploading.value = false;

        await Future.delayed(Duration(seconds: 1));

        Get.back();

        await initializeVideoPlayer();
      } else if (uploadType == profileImage) {
        profilePic.value = downloadUrl;

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

  @override
  void onInit() {
    getQualifications();
    titles.value = getTitlesAfterComma(lastNameTEC.text);

    super.onInit();
  }
}
