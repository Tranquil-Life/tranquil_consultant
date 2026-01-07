import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();

  RxBool isVerified = false.obs;
  RxBool isConfirmed = false.obs;
  var requesting = false.obs;
  var verificationToken = "".obs;
  var emailVerifiedAt = "".obs;

  AuthRepoImpl authRepo = AuthRepoImpl();

  Future verifyAccount(String token) async {
    var now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate =
        "${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)}";

    String formattedTime =
        "${now.hour.toString().padLeft(2, "0")}"
        ":${now.minute.toString().padLeft(2, "0")}"
        ":${now.second.toString().padLeft(2, "0")}";
    var formattedDateTime1 = DateTime.parse("$formattedDate $formattedTime");
    var formattedDateTime2 = formatter.format(formattedDateTime1);

    Either either = await authRepo.verifyAccount(token);

    either.fold((l) {
      isConfirmed.value = true;
      isVerified.value = false;

      CustomSnackBar.errorSnackBar(
          l.message.toString());
    }, (r) {
      verificationToken.value = token;
      isConfirmed.value = true;
      isVerified.value = true;
      emailVerifiedAt.value = formattedDateTime2;
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
        (l){
          return CustomSnackBar.errorSnackBar(l.message);
        }, (r) {
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
            (l) => CustomSnackBar.errorSnackBar(
            l.message.toString()), (r) {
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

      CustomSnackBar.errorSnackBar(
          l.message.toString());
    }, (r) {
      verificationToken.value = token;
      isConfirmed.value = true;
      isVerified.value = true;
    });
  }

}
