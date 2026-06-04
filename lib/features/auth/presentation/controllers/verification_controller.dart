import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/data/models/additional_license_model.dart';
import 'package:tl_consultant/features/auth/data/models/therapist_application_model.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();

  RxBool isVerified = false.obs;
  RxBool isConfirmed = false.obs;
  RxBool requesting = false.obs;
  RxString verificationToken = "".obs;
  RxString emailVerifiedAt = "".obs;
  RxBool emailIsValid = false.obs;
  RxInt currentStep = 0.obs;
  RxString profession = "".obs;
  final selectedProfession = ''.obs;
  final selectedState = ''.obs;
  var additionalLicenses = <AdditionalLicense>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = "".obs;

  //TEC for the verification eligibility fields
  final firstNameTEC = TextEditingController();
  final lastNameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final phoneTEC = TextEditingController();
  final licenseNumberController = TextEditingController();
  final npiController = TextEditingController();

  RxString firstName = ''.obs;
  RxString email = ''.obs;
  RxString token = ''.obs;

  AuthRepoImpl authRepo = AuthRepoImpl();

  Future verifyAccount(String token) async {
    var now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate =
        "${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)}";

    String formattedTime = "${now.hour.toString().padLeft(2, "0")}"
        ":${now.minute.toString().padLeft(2, "0")}"
        ":${now.second.toString().padLeft(2, "0")}";
    var formattedDateTime1 = DateTime.parse("$formattedDate $formattedTime");
    var formattedDateTime2 = formatter.format(formattedDateTime1);

    Either either = await authRepo.verifyAccount(token);

    either.fold((l) {
      isConfirmed.value = true;
      isVerified.value = false;

      CustomSnackBar.errorSnackBar(l.message.toString());
    }, (r) {
      verificationToken.value = token;
      isConfirmed.value = true;
      isVerified.value = true;
      emailVerifiedAt.value = formattedDateTime2;
    });
  }

  Future<bool> requestVerificationToken({required String email}) async {
    isVerified.value = false;
    isConfirmed.value = false;
    verificationToken.value = "";

    requesting.value = true;
    var tokenSent = false;

    Either either = await authRepo.requestVerificationToken(email: email);

    either.fold((l) {
      return CustomSnackBar.errorSnackBar(l.message);
    }, (r) {
      tokenSent = true;
    });

    requesting.value = false;

    return tokenSent;
  }

  Future<bool> requestPwdResetToken({required String email}) async {
    isVerified.value = false;
    isConfirmed.value = false;

    requesting.value = true;
    var tokenSent = false;

    Either either = await authRepo.requestResetPwdToken(email: email);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()), (r) {
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

      CustomSnackBar.errorSnackBar(l.message.toString());
    }, (r) {
      verificationToken.value = token;
      isConfirmed.value = true;
      isVerified.value = true;
    });
  }

  String? validateEmail() {
    final email = emailTEC.text.trim();

    if (email.isEmpty) {
      emailIsValid.value = false;
      return 'Email address is required';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      emailIsValid.value = false;
      return 'Enter a valid email address';
    }

    emailIsValid.value = true;
    return null;
  }

  void addLicense() {
    additionalLicenses.add(
      AdditionalLicense.empty(),
    );
  }

  void removeLicense(int index) {
    additionalLicenses.removeAt(index);
  }

  Future createApplication(TherapistApplication application) async {
    Either either =
        await authRepo.createTherapistApplication(application: application);

    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()), (r) {
      //display an alert dialog instead of a snackbar to inform the user that their application has been submitted and is under review.
      Get.defaultDialog(
        title: "Application Submitted",
        middleText:
            "Your application has been submitted and is under review. You will be notified via email once a decision has been made.",
        textConfirm: "OK",
        onConfirm: () {
          Get.offAllNamed(Routes.SIGN_IN);
        },
        buttonColor: ColorPalette.green,
      );
    });
  }

  Future<bool> validateInvitationToken(String enteredToken) async {
    isLoading.value = true;
    errorMessage.value = '';

    Either either = await authRepo.validateInvitationToken(enteredToken);

    return either.fold((l) {
      isLoading.value = false;
      errorMessage.value = l.message.toString();

      CustomSnackBar.errorSnackBar(
        l.message.toString(),
      );

      return false;
    }, (r) {
      Map<String, dynamic> data = r['data'];

      firstName.value = data['first_name'] ?? '';
      email.value = data['email'] ?? '';
      token.value = enteredToken;

      isLoading.value = false;
      errorMessage.value = '';

      return true;
    });
  }
}
