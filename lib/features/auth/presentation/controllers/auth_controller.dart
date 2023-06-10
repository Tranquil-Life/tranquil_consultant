import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/auth/domain/entities/register_data.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/data/repos/user_info_repo.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();

  UserDataStore userDataStore = UserDataStore();
  UserInfoRepoImpl userInfoRepoImpl = UserInfoRepoImpl();

  TextEditingController emailTEC = TextEditingController(text: "ayomideseaz@gmail.com");
  TextEditingController passwordTEC = TextEditingController(text: "password");

  TextEditingController cvTEC = TextEditingController();

  final dateTEC = TextEditingController();

  RegisterData params = RegisterData();

  String title = "Sign Up";
  RxBool isPasswordVisible = false.obs;

  RxBool uploading = false.obs;
  RxString fileSize = "0 KB".obs;

  var call = 0.obs;
  Timer? callTimer;

  Future signIn(String email, String password) async {
    var result = await AuthRepoImpl()
        .signIn(email, password);

    if(result.isRight()){
      result.map((r){
        //User user = UserModel.fromJson(r);
        userDataStore.user = r;
        //print("USER DATA: ${userDataStore.user}");
      });

      AppData.isSignedIn = true;
      User user = UserModel.fromJson(userDataStore.user);

      DashboardController.instance.authToken.value = user.authToken.toString();
      DashboardController.instance.displayName.value = user.displayName.toString();

      emailTEC.clear();
      passwordTEC.clear();


      if(user.authToken!.isNotEmpty){
        Get.offAllNamed(Routes.DASHBOARD);
      }

    }else{
      result.leftMap((l)=>
          CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red
          ));
    }
  }

  Future isUserAuthenticated() async{
    Timer.periodic(const Duration(seconds: 1), (timer) async{
      var result = await AuthRepoImpl().isUserAuthenticated();

      callTimer = timer;
      call.value++;

      if(result.isRight()){
        callTimer?.cancel();
        timer.cancel();

        result.map((r){
          userDataStore.user = r;
        });

        User user = UserModel.fromJson(userDataStore.user);

        DashboardController.instance.authToken.value = user.authToken.toString();
        DashboardController.instance.displayName.value = user.displayName.toString();

        Get.offAllNamed(Routes.DASHBOARD);
      }
      else{
        result.leftMap((l){

          if(call.value>=6){
            callTimer?.cancel();
            timer.cancel();

            print(l.message);
            if(l.message == "User has not been authenticated"){
              Get.offAllNamed(Routes.ONBOARDING);
            }

            CustomSnackBar.showSnackBar(
                context: Get.context!,
                title: "Error",
                message: l.message.toString(),
                backgroundColor: ColorPalette.red
            );
          }
        });
      }
    });
  }

  Future resetPassword() async{
    var either = await AuthRepoImpl().resetPassword(emailTEC.text);
    if(either.isRight()){
      bool val = either.isRight();
      debugPrint(val.toString());
    }
    else{
      either.leftMap((l)=>
          CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red
          ));
    }
  }

  RxString uploadUrl = "".obs;

  uploadFile(File file) async{
    await getFileSize(file.path, 1).then((value) async{
      if(value == "Too large"){
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: fileMaxSize,
            backgroundColor: ColorPalette.red);
      }else{
        uploading.value = true;
        var result = await userInfoRepoImpl
            .uploadCv(file, "cv");

        if(result.isRight()){
          result.map((r){
            params.cvUrl = r;
            uploadUrl.value = params.cvUrl;
            print("RIGHT:${AuthController.instance.params.cvUrl}");
          });
        }
        else{
          result.leftMap((l){
            CustomSnackBar.showSnackBar(
                context: Get.context!,
                title: "Error",
                message: l.message.toString(),
                backgroundColor: ColorPalette.red
            );
          });
        }      }
    });


  }

  Future getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();

    if(suffixes[i] != "B" && suffixes[i] !="KB"){
      if((bytes / pow(1024, i)) > 2){
        return "Too large";
      }else{
        return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
      }
    }else{
      return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
    }
  }

  clearData(){
    dateTEC.clear();
    params.email = '';
    params.password = '';
    call.value = 0;
  }

  @override
  void onClose() {
    callTimer?.cancel();
    clearData();

    super.onClose();
  }
}