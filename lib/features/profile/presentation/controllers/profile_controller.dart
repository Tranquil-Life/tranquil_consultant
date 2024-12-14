import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/profile_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/edit_user.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/qualification_fields.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();

  Rx<EditUser> editUser = EditUser().obs;

  ProfileRepoImpl profileRepo = ProfileRepoImpl();

  final TextEditingController firstNameTEC = TextEditingController(text: UserModel.fromJson(userDataStore.user).firstName);
  final TextEditingController lastNameTEC = TextEditingController(text: UserModel.fromJson(userDataStore.user).lastName);
  final TextEditingController countryTEC = TextEditingController();
  final TextEditingController cityTEC = TextEditingController();
  final TextEditingController bioTEC = TextEditingController(text: UserModel.fromJson(userDataStore.user).bio ?? '');
  final TextEditingController timeZoneTEC= TextEditingController();
  final TextEditingController titleTEC = TextEditingController();
  final TextEditingController certificationTEC = TextEditingController();
  final TextEditingController institutionTEC = TextEditingController();
  final TextEditingController yearGraduatedTEC = TextEditingController();
  final TextEditingController modalitiesTEC = TextEditingController();

  var qualifications = <Map<String,dynamic>>[
    {
      "id": 2,
      "consultant_id": 15,
      "certification": "Best Dancer",
      "institution": "School of Behaviorual Therapy",
      "year_awarded": "2012"
    }
  ].obs;
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
    // userDataStore.user['is_verified'] = user.isVerified;

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

  getMyLocationInfo() async{
    var result = await getCurrLocation();
    List<Placemark> placemarks = result['placemarks'];
    String country = placemarks.first.country!;
    String state = placemarks.first.administrativeArea!;
    int timezoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timezoneOffset / hourInMilliSecs;

    countryTEC.text = country;
    cityTEC.text = state;
    timeZoneTEC.text = "$formattedTimeZone";

    print('Current country: ${countryTEC.text}');
    print('Current city: ${cityTEC.text}');
    print('Current timezone: ${timeZoneTEC.text}');
  }

  @override
  void onInit() {
    getMyLocationInfo();
    super.onInit();
  }
}
