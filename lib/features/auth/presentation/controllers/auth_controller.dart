import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/data/repos/user_info_repo.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  UserDataStore userDataStore = UserDataStore();
  UserInfoRepoImpl userInfoRepoImpl = UserInfoRepoImpl();

  TextEditingController emailTEC =
      // TextEditingController(text: "apple2@gmail.com");
      TextEditingController(text: "ona97@example.org");
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

  String? currentAddress;
  Position? currentPosition;

  List workStatusList = ['Self-employed', 'Employed'];

  RxList<String> languagesArr = <String>[].obs;
  RxList<String> specialtiesArr = <String>[].obs;

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
        userDataStore.user = data['data'];
      }

      AppData.isSignedIn = true;

      await Get.offAllNamed(Routes.DASHBOARD);
      emailTEC.clear();
      passwordTEC.clear();
    });
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
