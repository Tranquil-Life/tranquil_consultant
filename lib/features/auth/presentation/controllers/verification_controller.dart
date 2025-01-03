import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
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

  AuthRepoImpl authRepo = AuthRepoImpl();

  Future verifyToken(String token) async {
    Either either = await authRepo.verifyAccount(token);
    either.fold((l) {
      isConfirmed.value = true;
      isVerified.value = false;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) {
      isConfirmed.value = true;
      isVerified.value = true;
    });
  }

  Future requestVerificationToken(
      {required String email, required String therapistKind}) async {
    isVerified.value = false;
    isConfirmed.value = false;

    requesting.value = true;

    Either either = await authRepo.requestVerificationToken(email: email);

    either.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      Get.to(SoloBasedVerification());
    });

    requesting.value = false;

  }
}
