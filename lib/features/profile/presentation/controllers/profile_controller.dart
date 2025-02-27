import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/functions.dart';
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

  var introVideoDuration = 0.obs;

  var profilePic = UserModel.fromJson(userDataStore.user).avatarUrl.obs;
  var introVideo = UserModel.fromJson(userDataStore.user).videoIntroUrl.obs;

  var meetingsCount = UserModel.fromJson(userDataStore.user).totalMeetings.obs;
  var clientsCount = UserModel.fromJson(userDataStore.user).totalClients.obs;
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

  List<Qualification> getQualifications() {
    qualifications.clear();

    if (userDataStore.qualifications.isNotEmpty) {
      int lastId = userDataStore.qualifications
          .where((item) => item.containsKey('id'))
          .fold<int>(
              0,
              (previousValue, item) => item['id'] > previousValue
                  ? item['id'] as int
                  : previousValue);

      for (var item in userDataStore.qualifications) {
        if (!item.containsKey('id') || item['id'] == null) {
          lastId += 1; // Increment lastId for new entries
          item['id'] = lastId;
        }

        qualifications.add(Qualification.fromJson(item));
      }
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
    if (qualifications.isNotEmpty) {
      userDataStore.qualifications =
          List<Map<String, dynamic>>.from(qualifications);

      getQualifications();
    }
  }

  restoreUser() {
    editUser.value = EditUser(baseUser: UserModel.fromJson(userDataStore.user));
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

  clearData() {
    introVideoDuration.value = 0;
    profilePic.value = '';
    introVideo.value = '';

    meetingsCount.value = 0;
    clientsCount.value = 0;
    firstNameTEC.clear();
    lastNameTEC.clear();
    phoneTEC.clear();
    countryTEC.clear();
    cityTEC.clear();
    bioTEC.clear();
    timeZoneTEC.clear();
    certificationTEC.clear();
    institutionTEC.clear();
    yearGraduatedTEC.clear();
    modalitiesTEC.clear();
    updatingProfile.value = false;

    qualifications.clear();
    modalities.clear();
    titles.clear();
    topics.clear();
  }

  @override
  void onInit() {
    getQualifications();
    titles.value = getTitlesAfterComma(lastNameTEC.text);

    super.onInit();
  }
}
