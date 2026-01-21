import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/data/store.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/media_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/profile_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find<ProfileController>();

  late MediaController mediaController;

  Rx<EditUser> editUser = EditUser().obs;

  dio.Dio dioObj = dio.Dio();

  ProfileRepoImpl profileRepo = ProfileRepoImpl();

  var introVideoDuration = 0.obs;

  // var profilePic = "".obs;
  // var introVideo = "".obs;

  // var meetingsCount = 0.obs;
  // var clientsCount = 0.obs;
  var deletingId =
      Rxn<int?>(); // Use null to indicate no qualification is being deleted

  final TextEditingController firstNameTEC = TextEditingController();
  final TextEditingController lastNameTEC = TextEditingController();
  final TextEditingController phoneTEC = TextEditingController();
  final TextEditingController countryTEC = TextEditingController();
  final TextEditingController stateTEC = TextEditingController();
  final TextEditingController bioTEC = TextEditingController();

  // final TextEditingController timeZoneTEC = TextEditingController();
  final TextEditingController certificationTEC = TextEditingController();
  final TextEditingController institutionTEC = TextEditingController();
  final TextEditingController yearGraduatedTEC = TextEditingController();

  // final TextEditingController modalitiesTEC = TextEditingController();

  var updatingProfile = false.obs;

  // var qualifications = <Qualification>[].obs;
  // RxList modalities = [].obs;
  RxList titles = [].obs;
  var topics = [].obs;

  // List<Qualification> getQualifications() {
  //   qualifications.clear();
  //
  //   if (userDataStore.qualifications.isNotEmpty) {
  //     int lastId = userDataStore.qualifications
  //         .where((item) => item.containsKey('id'))
  //         .fold<int>(
  //             0,
  //             (previousValue, item) => item['id'] > previousValue
  //                 ? item['id'] as int
  //                 : previousValue);
  //
  //     for (var item in userDataStore.qualifications) {
  //       if (!item.containsKey('id') || item['id'] == null) {
  //         lastId += 1; // Increment lastId for new entries
  //         item['id'] = lastId;
  //       }
  //
  //       qualifications.add(Qualification.fromJson(item));
  //     }
  //   }
  //
  //   return qualifications;
  // }

  // void containsTitle(String lastName) {
  //   bool exists = false;
  //   for (var e in titleOptions) {
  //     if (lastName.contains(e)) {
  //       exists = true;
  //     }
  //   }
  //
  //   if (exists) {
  //     lastNameTEC.text = lastName.split(',').first;
  //   }
  // }

  Future updateUser() async {
    final dashboardController = DashboardController.instance;
    final introVideo = dashboardController.videoIntro.value;
    final modalities = dashboardController.modalities;
    updatingProfile.value = true;

    User user = User(
        firstName: firstNameTEC.text,
        lastName: lastNameTEC.text,
        avatarUrl: dashboardController.profilePic.value,
        phoneNumber: phoneTEC.text,
        bio: bioTEC.text,
        videoIntroUrl: introVideo,
        specialties: modalities);

    var request = <String, dynamic>{};
    var qualificationReq = {'qualifications': userDataStore.qualifications};

    request.addAll(user.toJson());
    request.addAll(qualificationReq);

    final result = await profileRepo.updateProfile(request);

    print("REQUEST: $request");

    result.fold(
      (l) => CustomSnackBar.errorSnackBar(
        l.message!,
      ),
      (r) {
        editUser.value = EditUser(baseUser: UserModel.fromJson(r['user']));
        User user = UserModel.fromJson(r['user']);
        var qualifications = r['qualifications'] ?? [];

        updateProfile(user, qualifications, dashboardController);

        return CustomSnackBar.successSnackBar(body: "Profile updated");
      },
    );

    updatingProfile.value = false;
  }

  void updateProfile(
      User user, List qualifications, DashboardController dashboardController) {
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
    if (qualifications.isNotEmpty) {
      userDataStore.qualifications =
          List<Map<String, dynamic>>.from(qualifications);

      dashboardController.getQualifications();
    }

    dashboardController.restoreUserInfo();
  }

  ///restore user info
  // void restoreUser() {
  //   profilePic.value = UserModel.fromJson(userDataStore.user).avatarUrl;
  //   introVideo.value = UserModel.fromJson(userDataStore.user).videoIntroUrl!;
  //   firstNameTEC.text = UserModel.fromJson(userDataStore.user).firstName;
  //   lastNameTEC.text = UserModel.fromJson(userDataStore.user).lastName;
  //   phoneTEC.text = UserModel.fromJson(userDataStore.user).phoneNumber;
  //   bioTEC.text = UserModel.fromJson(userDataStore.user).bio;
  //   modalities.value = UserModel.fromJson(userDataStore.user).specialties!;
  //   meetingsCount.value = UserModel.fromJson(userDataStore.user).totalMeetings;
  //   clientsCount.value = UserModel.fromJson(userDataStore.user).totalClients;
  //
  //   if (userDataStore.qualifications.isNotEmpty) {
  //     var newList = List<Map<String, dynamic>>.from(userDataStore.qualifications);
  //     for (var e in newList) {
  //       qualifications.add(Qualification.fromJson(e));
  //     }
  //   }
  //
  //   final matches = titleOptions
  //       .where(
  //         (title) =>
  //             lastNameTEC.text.toLowerCase().contains(title.toLowerCase()),
  //       )
  //       .toList();
  //
  //   if (matches.isNotEmpty) {
  //     titles.value = matches;
  //   }
  //
  //   // editUser.value = EditUser(baseUser: UserModel.fromJson(userDataStore.user));
  // }

  void deleteQualification(int? id, int index) async {
    final dashboardController = DashboardController.instance;

    deletingId.value = id!; // Set the current deleting ID
    Future.delayed(Duration(seconds: 2), () {
      //remove from the userDataStore
      userDataStore.qualifications.removeAt(index);
      //remove from the DB
      deleteQualificationFromDB(id);

      deletingId.value = null; // Reset after deletion

      dashboardController.getQualifications();
    });
  }

  Future deleteQualificationFromDB(int id) async {
    Either either = await profileRepo.deleteQualification(id);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      CustomSnackBar.successSnackBar(body: "Qualification deleted");
    });
  }

  Future<void> updateProfilePicture() async {
    final dashboardController = DashboardController.instance;

    final bytes = await MediaController.pickImageBytesWeb();
    if (bytes == null) return;


    final url = await MediaController.uploadImage(
      bytes: bytes,
      folder: 'profile_image',
    );

    print('Uploaded URL: $url');

    dashboardController.profilePic.value = "$url";
    userDataStore.user['avatar_url'] = "$url";
    userDataStore.user = userDataStore.user;
  }

  void clearData() {
    introVideoDuration.value = 0;
    // profilePic.value = '';
    // introVideo.value = '';
    //
    // meetingsCount.value = 0;
    // clientsCount.value = 0;
    firstNameTEC.clear();
    lastNameTEC.clear();
    phoneTEC.clear();
    countryTEC.clear();
    stateTEC.clear();
    bioTEC.clear();
    // timeZoneTEC.clear();
    certificationTEC.clear();
    institutionTEC.clear();
    yearGraduatedTEC.clear();
    // modalitiesTEC.clear();
    updatingProfile.value = false;

    // qualifications.clear();
    // modalities.clear();
    titles.clear();
    topics.clear();

    userDataStore.user.clear();
    getStore.set(Keys.user, userDataStore.user);
  }



// @override
// void onInit() {
//   // getQualifications();
//   // titles.value = getTitlesAfterComma(lastNameTEC.text);
//
//   super.onInit();
// }
}
