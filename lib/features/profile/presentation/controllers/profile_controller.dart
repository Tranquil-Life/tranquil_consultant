import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/profile_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ProfileController extends GetxController{
  static ProfileController instance = Get.find();


  Rx<EditUser> editUser = EditUser().obs;

  ProfileRepoImpl repo = ProfileRepoImpl();

  updateUser(EditUser newUserData) async{
    //print(newUserData.toJson());
    final result = await repo.updateProfile(newUserData);

    result.fold(
          (l) => CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message!,
              backgroundColor: ColorPalette.red),
          (r) {
           editUser.value = EditUser(baseUser: UserModel.fromJson(r));
           User client = UserModel.fromJson(r);
           userDataStore.user['avatar_url'] = client.avatarUrl;
           userDataStore.user['f_name'] = client.firstName;
           userDataStore.user['l_name'] = client.lastName;
           userDataStore.user['phone'] = client.phoneNumber;
           userDataStore.user['birth_date'] = client.birthDate;
           userDataStore.user['gender'] = client.gender;
           userDataStore.user['staff_id'] = client.staffId;
           userDataStore.user['company_name'] = client.companyName;
           userDataStore.user['uses_bitmoji'] = client.usesBitmoji;
           userDataStore.user['is_verified'] = client.isVerified;

           userDataStore.user = userDataStore.user;

           CustomSnackBar.showSnackBar(
                context: Get.context!,
                title: "Success",
                message: "Profile updated",
                backgroundColor: ColorPalette.green);
      },
    );
  }

  void updateProfile() {
    userDataStore.user['f_name'] = editUser.value.firstName;
    userDataStore.user['l_name'] = editUser.value.lastName;
    userDataStore.user['phone'] = editUser.value.phoneNumber;
    userDataStore.user['avatar_url'] = editUser.value.avatarUrl;
    userDataStore.user['birth_date'] = editUser.value.birthDate;
    userDataStore.user['gender'] = editUser.value.gender;
    userDataStore.user['staff_id'] = editUser.value.staffId;
  }

  restoreUser(){
    editUser.value = EditUser(baseUser: UserModel.fromJson(userDataStore.user));
  }
}