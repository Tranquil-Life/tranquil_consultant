import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/data/place_result_model.dart';
import 'package:tl_consultant/core/data/places_search_response_model.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/data/models/stripe_account_model.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/create_stripe_account.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

class EarningsController extends GetxController {
  static EarningsController get instance => Get.find();

  final repo = WalletRepositoryImpl();

  // var balance = 0.00.obs;
  // var withdrawn = 0.00.obs;
  // var availableForWithdrawal = 0.00.obs;
  // var pendingClearance = 0.00.obs;
  // var stripeAccountId = "".obs;

  final amountTEC = TextEditingController();

  final bankNameTEC = TextEditingController();
  final bankAddressTEC = TextEditingController();

  final ibanTEC = TextEditingController();
  final swiftCodeTEC = TextEditingController();
  final accountNumberTEC = TextEditingController();
  final routingNumberTEC = TextEditingController();
  final accountHolderNameTEC = TextEditingController();
  final ssnTEC = TextEditingController();

  final recipientCountryTEC = TextEditingController();
  final recipientStateTEC = TextEditingController();
  final recipientCityTEC = TextEditingController();
  final recipientStreetTEC = TextEditingController();
  final recipientAptNoTEC = TextEditingController();
  final beneficiaryEmailTEC = TextEditingController();
  final beneficiaryNameTEC = TextEditingController();
  final beneficiaryFirstNameTEC = TextEditingController();
  final beneficiaryLastNameTEC = TextEditingController();
  final beneficiaryAddressTEC = TextEditingController();
  final beneficiaryPhoneTEC = TextEditingController();
  final postalCodeTEC = TextEditingController();

  final businessWebsiteTEC = TextEditingController();

  var phoneNumber = "".obs;

  final dobTEC = TextEditingController();
  final bankCountryTEC = TextEditingController();
  final bankStateTEC = TextEditingController();

  RxString frontIdPath = "".obs;
  RxString backIdPath = "".obs;

  RxBool acceptedTOS = false.obs;
  RxBool isSaved = false.obs;

  RxList<String> availableBranches = <String>[].obs;

  RxBool isCountryDropdownVisible = false.obs;
  RxBool isStateDropdownVisible = false.obs;
  RxBool isCityDropdownVisible = false.obs;
  RxString selectedCountry = ''.obs;

  RxList<Map<String, dynamic>> selectedCountryStates =
      <Map<String, dynamic>>[].obs;
  RxList selectedStateCities = [].obs;

  RxString nextPageToken = "".obs;
  RxBool isLoading = false.obs;

  // Rx<ExternalAccounts> externalAccounts = ExternalAccounts(data: []).obs;
  Rx<StripeAccountModel> stripeAccountModel = StripeAccountModel().obs;

  // Future getEarningsInfo() async {
  //   Either either = await repo.getWallet();
  //
  //   either.fold((l) {
  //     if (l.message! != 'Attempt to read property "id" on array') {
  //       return CustomSnackBar.showSnackBar(
  //           context: Get.context!,
  //           title: "Error",
  //           message: l.message!,
  //           backgroundColor: ColorPalette.red);
  //     }
  //   }, (r) {
  //     print(r);
  //     Earnings earnings = EarningsModel.fromJson(r['data']);
  //     // balance.value = roundToFiveSignificantFigures(earnings.balance);
  //     // withdrawn.value = roundToFiveSignificantFigures(earnings.withdrawn);
  //     // availableForWithdrawal.value =
  //     //     roundToFiveSignificantFigures(earnings.availableForWithdrawal);
  //     // pendingClearance.value =
  //     //     roundToFiveSignificantFigures(earnings.pendingClearance);
  //     stripeAccountId.value = earnings.stripeAccountId ?? "";
  //   });
  // }

  Future getStates({required String country}) async {
    selectedCountryStates.clear();

    Either either = await repo.getStates(country: country);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      var data = r['data'];
      var states = data['states'];
      for (var e in states) {
        selectedCountryStates.add(e);
      }
    });
  }

  Future getCities({required String country, required String state}) async {
    selectedStateCities.clear();

    Either either = await repo.getCities(country: country, state: state);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      var data = r['data'];
      for (var e in data) {
        selectedStateCities.add(e);
      }
    });
  }

  Future getBankBranches() async {
    nextPageToken.value = "";
    isLoading.value = true;
    availableBranches.clear();

    Either either = await repo.getBankBranches(
      bankName: bankNameTEC.text,
      state: bankStateTEC.text,
    );
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      if (r['next_page_token'] != null) {
        nextPageToken.value = r['next_page_token'];
      }
      PlacesSearchResponseModel placesSearchResponseModel =
          PlacesSearchResponseModel.fromJson(r);

      for (var e in placesSearchResponseModel.results) {
        PlaceResultModel placeResultModel = e;
        availableBranches.add(placeResultModel.formattedAddress);
      }

      isLoading.value = false;
    });
  }

  Future<void> fetchNextPage() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // required delay
    Either either =
        await repo.getFromNextPage(nextPageToken: nextPageToken.value);
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      nextPageToken.value = r['next_page_token'];
      PlacesSearchResponseModel placesSearchResponseModel =
          PlacesSearchResponseModel.fromJson(r);
      for (var e in placesSearchResponseModel.results) {
        PlaceResultModel placeResultModel = e;
        availableBranches.add(placeResultModel.formattedAddress);
      }

      isLoading.value = false;
    });
  }

  double roundToFiveSignificantFigures(double number) {
    // Convert the number to a string
    String numberString = number.toString();

    // Find the position of the first non-zero digit
    int firstNonZeroIndex = numberString.indexOf(RegExp('[^0.]'));

    // If the number is smaller than 1, the first non-zero digit might be after the decimal point
    if (firstNonZeroIndex > 0 && numberString[firstNonZeroIndex] == '.') {
      firstNonZeroIndex--;
    }

    // Calculate the end index for substring
    int endIndex = firstNonZeroIndex + 6;
    if (endIndex > numberString.length) {
      endIndex = numberString.length;
    }

    // Extract the significant figures
    String significantFigures = numberString.substring(0, endIndex);

    // Parse the string back to a double
    return double.parse(significantFigures);
  }

  clearData() {
    // balance.value = 0.00;
    // withdrawn.value = 0.00;
    // availableForWithdrawal.value = 0.00;
    // pendingClearance.value = 0.00;
  }

  toggleTosAcceptance() {
    acceptedTOS.value = !acceptedTOS.value;
  }

  toggleSave() {
    isSaved.value = !isSaved.value;
  }

  bool payoutExists() {
    if (stripeAccountId.isNotEmpty) {
      return true;
    }
    return false;
  }

  void createStripePayout() async {
    DateFormat inputFormat = DateFormat('MM-dd-yyyy'); //for US based
    DateTime? parsedDate;
    if (dobTEC.text.isNotEmpty) {
      parsedDate = inputFormat.parse(dobTEC.text);
    }

    CreateStripeAccount createStripeAccount = CreateStripeAccount(
        email: beneficiaryEmailTEC.text,
        phone: beneficiaryPhoneTEC.text,
        firstName: beneficiaryFirstNameTEC.text,
        lastName: beneficiaryLastNameTEC.text,
        dayOfBirth: parsedDate?.day,
        monthOfBirth: parsedDate?.month,
        yearOfBirth: parsedDate?.year,
        homeAddress: beneficiaryAddressTEC.text,
        city: recipientCityTEC.text,
        state: recipientStateTEC.text,
        businessWebsite:
            businessWebsiteTEC.text.isEmpty ? null : businessWebsiteTEC.text,
        postalCode: postalCodeTEC.text,
        accountNumber: accountNumberTEC.text,
        routingNumber: routingNumberTEC.text,
        holderName: accountHolderNameTEC.text,
        ssn: ssnTEC.text,
        frontOfID: File(frontIdPath.value),
        backOfID: backIdPath.value.isEmpty ? null : File(backIdPath.value),
        acceptedTOS: acceptedTOS.value);

    Either either = await repo.createStripeAccount(params: createStripeAccount);
    either.fold((l) {
      isSaved.value = false;
      return CustomSnackBar.errorSnackBar(l.message!);
    }, (r) {
      isSaved.value = true;
      print("success: $r");
    });
  }

  Future<double> getBalance() async {
    double balance = 0;
    Either either = await repo.getBalance();
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      var data = r['data'];
      if (data != null) {
        balance = double.parse(balance.toString());
      }
    });

    return balance;
  }

  Future<double> getLifeTimeTotal() async {
    double totalVolReceived = 0;
    Either either = await repo.getLifeTimeTotalReceived();
    either.fold((l) {
      return CustomSnackBar.errorSnackBar(l.message!);
    }, (r) {
      var data = r['data'];
      if (data != null) {
        totalVolReceived = double.parse(data['total_volume_received'].toString());
      }
    });

    return totalVolReceived;
  }

  Future<double> getPendingClearance() async {
    double pendingClearance = 0;
    Either either = await repo.getTotalPendingClearance();
    either.fold((l){
      return CustomSnackBar.errorSnackBar(l.message!);
    }, (r) {
      pendingClearance = (r['pending_amount'] as num).toDouble();
    });

    return pendingClearance;
  }

  void withdrawEarnings() async{
    var req = {
      "account_id": stripeAccountId,
      "amount": amountTEC.text,
    };
    Either either = await repo.withdrawToBankAcc(req);
    either.fold((l)=>CustomSnackBar.errorSnackBar(l.message!), (r){
      print(r);
    });
  }

  void getStripeAccountInfo() async {
    if (stripeAccountId.isNotEmpty) {
      Either either = await repo.getStripeAccountInfo();

      either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
        var data = r['data'];

        if (data != null) {
          stripeAccountModel.value = StripeAccountModel.fromJson(data);
          //Name
          // beneficiaryFirstNameTEC.text =
          //     stripeAccountModel.individual.firstName;
          // beneficiaryLastNameTEC.text = stripeAccountModel.individual.lastName;
          // beneficiaryNameTEC.text =
          //     "${beneficiaryFirstNameTEC.text} ${beneficiaryLastNameTEC.text}";
          //
          // //Email
          // beneficiaryEmailTEC.text = stripeAccountModel.individual.email;
          //
          // //date of birth
          // var month = stripeAccountModel.individual.dateOfBirth.month;
          // var day = stripeAccountModel.individual.dateOfBirth.day;
          // var year = stripeAccountModel.individual.dateOfBirth.year;
          // dobTEC.text = "$month-$day-$year";
          //
          // //Address
          // recipientCountryTEC.text =
          //     stripeAccountModel.individual.address.country;
          // recipientStateTEC.text = stripeAccountModel.individual.address.state;
          // recipientCityTEC.text = stripeAccountModel.individual.address.city;
          // recipientStreetTEC.text = stripeAccountModel.individual.address.line1;
          // recipientAptNoTEC.text =
          //     stripeAccountModel.individual.address.line2!.toString();
          // postalCodeTEC.text = stripeAccountModel.individual.address.postalCode;
          // beneficiaryAddressTEC.text =
          //     "${postalCodeTEC.text.isEmpty ? "" : "${postalCodeTEC.text},"} "
          //     "${recipientAptNoTEC.text.isEmpty ? "" : "${recipientAptNoTEC.text},"} "
          //     "${recipientStreetTEC.text.isEmpty ? "" : "${recipientStreetTEC.text},"} "
          //     "${recipientStateTEC.text.isEmpty ? "" : "${recipientStateTEC.text},"} "
          //     "${recipientCountryTEC.text}";
          //
          // accountNumberTEC.text =
        }
      });
    }
  }

  void updateStripePayout() {}


}
