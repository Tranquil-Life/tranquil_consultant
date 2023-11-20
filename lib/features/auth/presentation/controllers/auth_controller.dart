import 'dart:async';
import 'dart:io';

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

class AuthController extends GetxController{
  static AuthController instance = Get.find();

  UserDataStore userDataStore = UserDataStore();
  UserInfoRepoImpl userInfoRepoImpl = UserInfoRepoImpl();

  TextEditingController emailTEC = TextEditingController(text: "ona97@example.org");
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


  var call = 0.obs;
  Timer? callTimer;

  String? currentAddress;
  Position? currentPosition;

  List workStatusList = ['Self-employed', 'Employed'];

  RxList<String> languagesArr = <String>[].obs;
  RxList<String> specialtiesArr = <String>[].obs;


  Future signUp()async{
    var either = await AuthRepoImpl().register(params);
    if(either.isRight()) {
      either.map((r){
        userDataStore.user = r;
      });

      AppData.isSignedIn = true;
      User user = UserModel.fromJson(userDataStore.user);

      if(user.authToken!.isNotEmpty){
        Get.offAllNamed(Routes.DASHBOARD);

        emailTEC.clear();
        passwordTEC.clear();
      }
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

  Future signIn(String email, String password) async {
    var result = await AuthRepoImpl()
        .signIn(email, password);
    if(result.isRight()){
      result.map((r){
        userDataStore.user = r;
      });

      AppData.isSignedIn = true;
      User user = UserModel.fromJson(userDataStore.user);

      if(user.authToken!.isNotEmpty){
        Get.offAllNamed(Routes.DASHBOARD);

        emailTEC.clear();
        passwordTEC.clear();
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

  Future<String> generateFcmToken() async{
    var result = await AuthRepoImpl().generateFcmToken();
    String token = "";
    if(result.isRight()){
      result.map((r)=>token = r);

      return token;

    }else{
      result.leftMap((l)=>
          CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red
          ));

      return "";
    }
  }

  Future updateFcmToken() async{
    String fcmToken = await generateFcmToken();

    if(fcmToken.isNotEmpty){
      // Sends the current token to the endpoint
      await sendTokenToEndpoint(fcmToken);
    }
  }

  Future sendTokenToEndpoint(String fcmToken) async{
    var result = await AuthRepoImpl().sendTokenToEndpoint(fcmToken);
    if(result.isRight()){
      result.map((r) => print(r.toString()));
    }else{
      result.leftMap((l) => CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red
      ));
    }
  }

  uploadCv({File? file}) async{
    await getFileSize(file!.path, 1).then((value) async{
      if(value == "Too large"){
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: fileMaxSize,
            backgroundColor: ColorPalette.red);
      }else{
        uploading.value = true;

        Timer.periodic(const Duration(seconds: 1), (timer) async{
          var result = await userInfoRepoImpl
              .uploadCv(file);

          if(result.isRight()){
            callTimer?.cancel();
            timer.cancel();

            result.map((r){
              params.cvUrl = r;
              uploadUrl.value = params.cvUrl;
            });
          }
          else{
            result.leftMap((l){
              if(call.value>=6){
                callTimer?.cancel();
                timer.cancel();

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
    });
  }

  uploadID({File? file}) async{
    uploading.value = true;

    var result = await userInfoRepoImpl
        .uploadID(file!);

    Timer.periodic(Duration(seconds: 1), (timer) {
      if(result.isRight()){
        callTimer?.cancel();
        timer.cancel();

        result.map((r){
          params.identityUrl = r;
          uploadUrl.value = params.identityUrl;
        });
      }
      else{
        result.leftMap((l){
          if(call.value>=6){
            callTimer?.cancel();
            timer.cancel();

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

  clearData(){
    emailTEC.clear();
    passwordTEC.clear();
    cvTEC.clear();
    identityTEC.clear();
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