import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/data/place_result_model.dart';
import 'package:tl_consultant/core/data/places_search_response_model.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';
import 'package:tl_consultant/features/wallet/domain/entities/stripe_account.dart';

class EarningsController extends GetxController {
  static EarningsController get instance => Get.find();

  final repo = WalletRepositoryImpl();

  var balance = 0.00.obs;
  var withdrawn = 0.00.obs;
  var availableForWithdrawal = 0.00.obs;
  var pendingClearance = 0.00.obs;

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


  Future getEarningsInfo() async {
    Either either = await repo.getWallet();

    either.fold((l) {
      if (l.message! != 'Attempt to read property "id" on array') {
        return CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message!,
            backgroundColor: ColorPalette.red);
      }
    }, (r) {
      Earnings earnings = EarningsModel.fromJson(r['data']);
      balance.value = roundToFiveSignificantFigures(earnings.balance);
      withdrawn.value = roundToFiveSignificantFigures(earnings.withdrawn);
      availableForWithdrawal.value =
          roundToFiveSignificantFigures(earnings.availableForWithdrawal);
      pendingClearance.value =
          roundToFiveSignificantFigures(earnings.pendingClearance);
    });
  }

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

    print(availableBranches);
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
    balance.value = 0.00;
    withdrawn.value = 0.00;
    availableForWithdrawal.value = 0.00;
    pendingClearance.value = 0.00;
  }

  toggleTosAcceptance(){
    acceptedTOS.value = !acceptedTOS.value;
  }

  bool payoutExists(){
    return false;
  }

  void createStripePayout() async{
    DateFormat inputFormat = DateFormat('MM-dd-yyyy'); //for US based
    DateTime? parsedDate;
    if(dobTEC.text.isNotEmpty){
      parsedDate = inputFormat.parse(dobTEC.text);
    }

    StripeAccount stripeAccount = StripeAccount(
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
        businessWebsite: businessWebsiteTEC.text.isEmpty ? null : businessWebsiteTEC.text,
        postalCode: postalCodeTEC.text,
        accountNumber: accountNumberTEC.text,
        routingNumber: routingNumberTEC.text,
        holderName: accountHolderNameTEC.text,
        ssn: ssnTEC.text,
        frontOfID: File(frontIdPath.value),
        backOfID: backIdPath.value.isEmpty ? null : File(backIdPath.value),
        acceptedTOS: acceptedTOS.value);

    Either either = await repo.createStripeAccount(params: stripeAccount);
    either.fold((l){
      print(l.message!);
      return CustomSnackBar.errorSnackBar(l.message!);
    }, (r){
      print("success: $r");
    });
  }
}
