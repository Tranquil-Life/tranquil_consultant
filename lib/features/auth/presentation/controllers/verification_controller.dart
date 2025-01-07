import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/agency_based_verification.dart';
import 'package:tl_consultant/features/auth/presentation/screens/register/solo_based_verification.dart';

class VerificationController extends GetxController {
  RxBool isVerified = false.obs;
  RxBool isConfirmed = false.obs;
  var requesting = false.obs;
  var verificationToken = "".obs;

  AuthRepoImpl authRepo = AuthRepoImpl();

  Future verifyAccount(String token) async {
    Either either = await authRepo.verifyAccount(token);

    either.fold((l) {
      isConfirmed.value = true;
      isVerified.value = false;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) {
      verificationToken.value = token;
      isConfirmed.value = true;
      isVerified.value = true;
    });
  }

  Future<bool> requestVerificationToken(
      {required String email}) async {
    isVerified.value = false;
    isConfirmed.value = false;
    verificationToken.value = "";

    requesting.value = true;
    var tokenSent = false;

    Either either = await authRepo.requestVerificationToken(email: email);

    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      tokenSent = true;
    });

    requesting.value = false;

    return tokenSent;
  }

  Future<bool> requestPwdResetToken({required String email}) async{
    isVerified.value = false;
    isConfirmed.value = false;

    requesting.value = true;
    var tokenSent = false;


    Either either = await authRepo.requestResetPwdToken(email: email);
    either.fold(
            (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      tokenSent = true;
    });

    requesting.value = false;

    return tokenSent;
  }

  Future verifyResetToken(String token) async {
    Either either = await authRepo.verifyResetToken(token);

    either.fold((l) {
      isConfirmed.value = true;
      isVerified.value = false;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) {
      verificationToken.value = token;
      isConfirmed.value = true;
      isVerified.value = true;
    });
  }

}
