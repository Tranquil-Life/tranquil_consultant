import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/profile_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();

  Rx<EditUser> editUser = EditUser().obs;

  ProfileRepoImpl profileRepo = ProfileRepoImpl();

  updateUser(EditUser newUserData) async {
    final result = await profileRepo.updateProfile(newUserData);

    result.fold(
      (l) => CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message!,
          backgroundColor: ColorPalette.red),
      (r) {
        editUser.value = EditUser(baseUser: UserModel.fromJson(r['data']));
        User user = UserModel.fromJson(r['data']);
        updateProfile(user);

        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Success",
            message: "Profile updated",
            backgroundColor: ColorPalette.green);
      },
    );
  }

  void updateProfile(User user) {
    userDataStore.user['avatar_url'] = user.avatarUrl;
    userDataStore.user['f_name'] = user.firstName;
    userDataStore.user['l_name'] = user.lastName;
    userDataStore.user['phone'] = user.phoneNumber;
    userDataStore.user['birth_date'] = user.birthDate;
    userDataStore.user['gender'] = user.gender;
    userDataStore.user['staff_id'] = user.staffId;
    userDataStore.user['company_name'] = user.companyName;
    userDataStore.user['uses_bitmoji'] = user.usesBitmoji;
    userDataStore.user['is_verified'] = user.isVerified;

    userDataStore.user = userDataStore.user;
  }

  restoreUser() {
    editUser.value = EditUser(baseUser: UserModel.fromJson(userDataStore.user));
  }

  getContinent(placemarks) async {
    Either either = await profileRepo.currentContinent();

    var continent = "";

    either.fold((l) {
      if (l.message.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Internet Error",
            message: "Change your internet provider",
            backgroundColor: ColorPalette.red);
      } else {
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message,
            backgroundColor: ColorPalette.red);
      }
    }, (r) {
      final jsonData = r;

      final countries = jsonData;

      for (var country in countries) {
        if (country['country'] == placemarks.first.country) {
          continent = country['continent'];
          break;
        }
      }
    });

    return continent;
  }
}
