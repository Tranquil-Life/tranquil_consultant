import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/stripe_transaction.dart';
import 'package:tl_consultant/features/wallet/domain/entities/transaction.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';

class TransactionsController extends GetxController {
  static TransactionsController instance = Get.find();

  final earningsController = EarningsController.instance;

  WalletRepositoryImpl walletRepo = WalletRepositoryImpl();

  var currPageIndex = 0.obs;

  // RxList<Transaction> transactions = <Transaction>[].obs;

  RxList<StripeTransaction> stripeTrnx = <StripeTransaction>[].obs;
  RxString? startingAfter;

  //pagination vars
  var page = 1.obs;
  var limit = 10.obs;

  // There is next page or not
  var hasNextPage = true.obs;

  // Used to display loading indicators when _firstLoad function is running
  var isFirstLoadRunning = false.obs;

  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;

  // The controller for the ListView
  late ScrollController scrollController;

  Future loadInitialStripeTranx() async {
    var result = await walletRepo.getStripeTransactions(
        startingAfter: startingAfter?.value,
        accountId: "${UserModel.fromJson(userDataStore.user).stripeAccountId}");
    isFirstLoadRunning.value = true;

    result.fold(
        (l) => CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.red), (r) {
      stripeTrnx.clear();
      result.map((r) => stripeTrnx.value = (r['data']['transactions'] as List)
          .map((e) => StripeTransaction.fromJson(e))
          .toList());
    });

    update();

    print("Transactions: $stripeTrnx");

    isFirstLoadRunning.value = false;
  }

  Future loadMoreStripeTranx() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.position.extentAfter < 300) {
      isLoadMoreRunning.value =
          true; // Display a progress indicator at the bottom
      page.value += 1; // Increase _page by 1

      var result = await walletRepo.getStripeTransactions(
          startingAfter: startingAfter?.value,
          accountId:
              "${UserModel.fromJson(userDataStore.user).stripeAccountId}");

      isLoadMoreRunning.value = false; // Hide the loading indicator

      if (result.isRight()) {
        result.map((r) {
          // If we have new transactions, add them to the existing list
          List<StripeTransaction> fetchedTransactions =
              (r['data']['transactions'] as List).map((e) => StripeTransaction.fromJson(e)).toList();

          // Check if there are transactions to add
          if (fetchedTransactions.isNotEmpty) {
            stripeTrnx.addAll(fetchedTransactions); // Add to the existing list
          } else {
            // No more data to load, set hasNextPage to false
            hasNextPage.value = false;
          }
        });
      } else {
        // Show an error message if fetching the transactions fails
        result.leftMap((l) => CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red,
            ));
      }

      update();
    }
  }

  clearData() {
    currPageIndex.value = 0;
    stripeTrnx.clear();
    page.value = 1;
    limit.value = 10;
    hasNextPage.value = false;
    isFirstLoadRunning.value = false;
    isLoadMoreRunning.value = false;
  }
}
