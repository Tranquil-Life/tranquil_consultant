import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

class EarningsController extends GetxController {
  static EarningsController instance = Get.find();

  final repo = WalletRepositoryImpl();

  var balance = 0.00.obs;
  var withdrawn = 0.00.obs;
  var availableForWithdrawal = 0.00.obs;
  var pendingClearance = 0.00.obs;

  Future getEarningsInfo() async {
    Either either = await repo.getWallet();

    either.fold((l) {
      if(l.message! != 'Attempt to read property "id" on array'){
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

  clearData(){
    balance.value = 0.00;
    withdrawn.value = 0.00;
    availableForWithdrawal.value = 0.00;
    pendingClearance.value = 0.00;
  }
}
