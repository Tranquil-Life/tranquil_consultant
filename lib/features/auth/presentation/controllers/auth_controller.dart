import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/auth/domain/entities/register_data.dart';
import 'package:tl_consultant/features/media/data/media_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/data/repos/user_info_repo.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  UserDataStore userDataStore = UserDataStore();
  UserInfoRepoImpl userInfoRepoImpl = UserInfoRepoImpl();
  AuthRepoImpl authRepo = AuthRepoImpl();
  MediaRepoImpl mediaRepo = MediaRepoImpl();

  TextEditingController emailTEC =
      // TextEditingController(text: "apple2@gmail.com");
      TextEditingController();

  // TextEditingController passwordTEC = TextEditingController(text: "password");
  TextEditingController confirmPasswordTEC = TextEditingController();

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
  final isLengthValid = false.obs;
  final hasSpecialChar = false.obs;
  final hasDigit = false.obs;
  final hasLetter = false.obs;
  final isPasswordsMatching = false.obs;

  //For sign in validation
  final emailIsValid = false.obs;
  final passwordIsValid = false.obs;

  var loading = false.obs;

  var introVideo = "".obs;
  var introVideoDuration = 0.obs;

  var profilePic = "".obs;

  String? currentAddress;
  Position? currentPosition;

  List workStatusList = ['Self-employed', 'Employed'];

  RxList<String> languagesArr = <String>[].obs;
  RxList<String> specialtiesArr = <String>[].obs;

  var selectedType = ''.obs;

  Future signUp() async {
    params.email = emailTEC.text;
    params.videoIntro = introVideo.value;
    params.pictureUrl = profilePic.value;
    params.therapistKind = selectedType.value;

    Either either = await authRepo.register(params);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) async {
      Map<String, dynamic> data = r;
      userDataStore.user = data['data']['user'];
      userDataStore.qualifications =
          List<Map<String, dynamic>>.from(data['data']['qualifications']);
      userDataStore.user['meetings_count'] = data['data']['meetings_count'];
      userDataStore.user['clients_count'] = data['data']['clients_count'];

      AppData.isSignedIn = true;
      User user = UserModel.fromJson(userDataStore.user);

      if (kDebugMode) {
        print(user.toJson());
      }

      await Get.offAllNamed(Routes.DASHBOARD);
      emailTEC.clear();
      confirmPasswordTEC.clear();
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
        userDataStore.qualifications =
            List<Map<String, dynamic>>.from(data['data']['qualifications']);
        userDataStore.user['meetings_count'] = data['data']['meetings_count'];
        userDataStore.user['clients_count'] = data['data']['clients_count'];

        print("User: ${userDataStore.user}");

        AppData.isSignedIn = true;

        await updateFcmToken();

        await Get.offAllNamed(Routes.DASHBOARD);

        emailTEC.clear();
        confirmPasswordTEC.clear();
      }
    });

    loading.value = false;
  }

  Future resetPassword() async {
    var either = await AuthRepoImpl().resetPassword(emailTEC.text);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      bool val = either.isRight();
      debugPrint(val.toString());
    });
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

  Future updateFcmToken() async {
    String fcmToken = await generateFcmToken();

    if (fcmToken.isNotEmpty) {
      // Sends the current token to the endpoint
      await sendTokenToEndpoint(fcmToken);
    }
  }

  Future sendTokenToEndpoint(String fcmToken) async {
    Either either = await authRepo.sendTokenToEndpoint(fcmToken);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()),
        (r) => debugPrint(r.toString()));
  }

  Future<String> generateFcmToken() async {
    String token = "";

    Either either = await authRepo.generateFcmToken();
    either.fold((l) {
      CustomSnackBar.errorSnackBar(l.message.toString());
      return token;
    }, (r) {
      token = r;
      return token;
    });

    return token;
  }

  String? signInValidation() {
    if (emailTEC.text.isEmpty) {
      emailIsValid.value = false;
      return 'Email address is required';
    } else if (params.password.isEmpty) {
      passwordIsValid.value = false;
      return 'Password is required';
    } else if (emailTEC.text.isEmpty && params.password.isEmpty) {
      return 'Both fields are required';
    }
    emailIsValid.value = true;
    passwordIsValid.value = true;

    return null;
  }

  String? validatePassword() {
    if (params.password.isEmpty) {
      _resetPasswordCriteria();
      return 'Password is required';
    }

    isLengthValid.value =
        params.password.length > 8 && !params.password.contains(' ');
    hasSpecialChar.value =
        RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(params.password);
    hasDigit.value = RegExp(r'\d').hasMatch(params.password);
    hasLetter.value = RegExp(r'[a-zA-Z]').hasMatch(params.password);
    isPasswordsMatching.value = params.password == confirmPasswordTEC.text;

    return isAllPwdCriteriaMet ? null : 'Password does not meet criteria';
  }

  String? validatePasswordMatch() {
    if (params.password.isEmpty || confirmPasswordTEC.text.isEmpty) {
      isPasswordsMatching.value = false;
      return '';
    }

    if (params.password != confirmPasswordTEC.text) {
      isPasswordsMatching.value = false;
      return '';
    }

    isPasswordsMatching.value = true;
    return null;
  }

  Future updatePassword(
      {required String token, required String password}) async {
    var updated = false;
    Either either =
        await authRepo.updatePassword(token: token, password: password);
    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) async {
          updated = true;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          message: "Password updated successfully",
          backgroundColor: ColorPalette.green);
    });

    return updated;
  }

  bool get isAllPwdCriteriaMet =>
      isLengthValid.value &&
      hasSpecialChar.value &&
      hasDigit.value &&
      hasLetter.value &&
      isPasswordsMatching.value;

  void _resetPasswordCriteria() {
    isLengthValid.value = false;
    hasSpecialChar.value = false;
    hasDigit.value = false;
    hasLetter.value = false;
    isPasswordsMatching.value = false;
  }

  clearData() {
    emailTEC.clear();
    confirmPasswordTEC.clear();
    cvTEC.clear();
    identityTEC.clear();
    currLocationTEC.clear();
    areaOfExpertiseTEC.clear();
    yearsOfExperienceTEC.clear();
    languagesTEC.clear();
    dateTEC.clear();

    params.email = '';
    params.password = '';

    isPasswordVisible.value = false;
    isLengthValid.value = false;

    hasSpecialChar.value = false;
    hasDigit.value = false;
    hasLetter.value = false;
    isPasswordsMatching.value = false;
    emailIsValid.value = false;
    passwordIsValid.value = false;

    loading.value = false;

    introVideo.value = '';
    introVideoDuration.value = 0;

    profilePic.value = '';
  }

  @override
  void onClose() {
    clearData();

    super.onClose();
  }
}
