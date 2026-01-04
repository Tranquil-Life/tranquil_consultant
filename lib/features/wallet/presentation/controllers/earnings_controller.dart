import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/data/place_result_model.dart';
import 'package:tl_consultant/core/data/places_search_response_model.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/features/wallet/data/models/stripe_account_model.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/create_stripe_account.dart';

class EarningsController extends GetxController {
  static EarningsController get instance => Get.find();

  final repo = WalletRepositoryImpl();

  var totalBalance = 0.00.obs;
  var futurePayout = 0.00.obs;
  var inTransit = 0.00.obs;

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

  // Future<void> fetchNextPage() async {
  //   isLoading.value = true;
  //   await Future.delayed(Duration(seconds: 2)); // required delay
  //   Either either =
  //       await repo.getFromNextPage(nextPageToken: nextPageToken.value);
  //   either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
  //     nextPageToken.value = r['next_page_token'];
  //     PlacesSearchResponseModel placesSearchResponseModel =
  //         PlacesSearchResponseModel.fromJson(r);
  //     for (var e in placesSearchResponseModel.results) {
  //       PlaceResultModel placeResultModel = e;
  //       availableBranches.add(placeResultModel.formattedAddress);
  //     }
  //
  //     isLoading.value = false;
  //   });
  // }

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

  void toggleTosAcceptance() {
    acceptedTOS.value = !acceptedTOS.value;
  }

  void toggleSave() {
    isSaved.value = !isSaved.value;
  }

  bool payoutExists() {
    if (stripeAccountId != null) {
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
      // print("success: $r");
    });
  }

  Future<double> getBalance() async {
    double balance = 0.0;

    final either = await repo.getBalance();
    either.fold((l) {
      final msg = l.message;
      if (msg == null) return;

      if (!msg.contains('unauthenticated')) {
        switch (msg) {
          case notConnectedAccountMsg:
            print("balance: error: $msg");
            break;
          default:
            CustomSnackBar.errorSnackBar("balance: error: $msg");
        }
      }
    }, (r) {
      if (r is Map) {
        final data = r['data'];
        if (data is Map) {
          // Guard: available must be a non-empty List and contain a Map with 'amount'
          final available = data['available'];
          if (available is List && available.isNotEmpty) {
            final first = available.first;
            final num? cents = (first is Map) ? first['amount'] as num? : null;

            // Convert cents to dollars (or your base unit) safely
            balance = cents != null ? (cents / 100.0) : 0.0;

            try {
              futurePayout.value = balance;
            } catch (_) {
              // swallow if futurePayout isn’t ready; optional: log
            }
          } else {
            balance = 0.0;
          }
        }
      }
    });

    return balance;
  }


  Future<double> getLifeTimeTotal() async {
    double totalVolReceived = 0.0;

    final either = await repo.getLifeTimeTotalReceived();
    either.fold((l) {
      final msg = l.message; // might be null!
      if (msg == null) {
        // log silently, or show a generic error if you want
        return;
      }

      if (!msg.contains('unauthenticated')) {
        switch (msg) {
          case notConnectedAccountMsg:
          // keep print if you prefer
            print("lifetime volume received: error: $msg");
            break;
          default:
            CustomSnackBar.errorSnackBar("lifetime volume received: error: $msg");
        }
      }
    }, (r) {
      // r could be Map or something else—guard it
      if (r is Map && r['data'] != null) {
        final data = r['data'];
        // handle nulls safely
        final num? raw = (data is Map) ? data['total_volume_received'] as num? : null;
        totalVolReceived = raw?.toDouble() ?? 0.0;
      }
    });

    return totalVolReceived; // always a double, never null
  }

  Future<double> getPendingClearance() async {
    double pendingClearance = 0.0;

    final either = await repo.getTotalPendingClearance();

    either.fold((l) {
      final msg = l.message; // might be null
      if (msg == null) {
        // optionally log silently or show a generic error
        return;
      }

      if (!msg.contains('unauthenticated')) {
        switch (msg) {
          case notConnectedAccountMsg:
            print("pending clearance: error: $msg");
            break;
          default:
            CustomSnackBar.errorSnackBar("pending clearance: error: $msg");
        }
      }
    }, (r) {
      // Defensive: check that r is a Map and contains numeric value
      if (r is Map) {
        final num? raw = r['pending_amount'] as num?;
        pendingClearance = raw?.toDouble() ?? 0.0;
      }
    });

    return pendingClearance;
  }


  Future<double> getAmountInTransitToBank() async {
    double amountInTransit = 0.0;

    final either = await repo.getAmountInTransitToBank();
    either.fold((l) {
      final msg = l.message;
      if (msg == null) return;

      if (!msg.contains('unauthenticated')) {
        switch (msg) {
          case notConnectedAccountMsg:
            print("amount in transit: error: $msg");
            break;
          default:
            CustomSnackBar.errorSnackBar("amount in transit: error: $msg");
        }
      }
    }, (r) {
      if (r is Map) {
        final data = r['data'];
        if (data is Map) {
          final num? raw = data['amount_in_transit'] as num?;
          amountInTransit = raw?.toDouble() ?? 0.0;

          // Update observable only when we have a valid number
          try {
            inTransit.value = amountInTransit;
          } catch (_) {
            // swallow if inTransit isn’t ready; optional: log
          }
        }
      }
    });

    return amountInTransit;
  }

  Future getStripeAccountInfo() async {
    if (stripeAccountId != null) {
      Either either = await repo.getStripeAccountInfo();

      either.fold((l) {
        switch (l.message!) {
          case notConnectedAccountMsg:
            break;
          default:
            CustomSnackBar.errorSnackBar(
                "stripe account info: error: ${l.message!}");
        }
      }, (r) {
        var data = r['data'];

        if (data != null) {
          stripeAccountModel.value = StripeAccountModel.fromJson(data);
        }
      });
    }
  }

  void withdrawEarnings() async {
    var req = {
      "account_id": stripeAccountId,
      "amount": amountTEC.text,
    };
    Either either = await repo.withdrawToBankAcc(req);
    either.fold((l) {
      print("withdraw earnings: error: ${l.message!}");
      CustomSnackBar.errorSnackBar(l.message!);
    }, (r) {
      amountTEC.clear(); //clear amount to withdraw field

      CustomSnackBar.successSnackBar(
          body: "\$${amountTEC.text} withdrawn successfully");
    });
  }

  void updateStripePayout() {}
  
  void getStripeTransactions(){

  }

  void clearData() {}
}
