import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/transaction.dart';


class TransactionsController extends GetxController{
  static TransactionsController instance = Get.find();

  WalletRepositoryImpl walletRepo = WalletRepositoryImpl();

  var currPageIndex = 0.obs;
  RxList<Transaction> transactions = <Transaction>[].obs;

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

  loadfirstTransactions() async{
    print("${page.value}:${limit.value}");
    var result = await walletRepo.getTransactions(page: page.value, limit: limit.value);

    isFirstLoadRunning.value = true;

    if(result.isRight()){
      result.map((r) => transactions.value = (r as List).map((e) => Transaction.fromJson(e)).toList());
    }else{
      result.leftMap((l)
      => CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red)
      );
    }
    update();

    isFirstLoadRunning.value = false;
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  loadMoreTransactions() async{
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.position.extentAfter < 300)
    {
      isLoadMoreRunning.value = true; // Display a progress indicator at the bottom
      page.value += 1;// Increase _page by 1

      var result = await walletRepo.getTransactions(page: page.value, limit: limit.value);

      // if(result.isRight()){
      //   List<Transaction> fetchedTransactions = [];
      //
      //   result.map((r) => fetchedTransactions = (r as List).map((e) => Transaction.fromJson(e)).toList());
      //   if (fetchedTransactions.isNotEmpty) {
      //     transactions.addAll(fetchedTransactions);
      //   } else {
      //     // This means there is no more data
      //     // and therefore, we will not send another GET request
      //     hasNextPage.value = false;
      //   }
      //
      //   isLoadMoreRunning.value = false;
      //
      // }else{
      //   result.leftMap((l)
      //   => CustomSnackBar.showSnackBar(
      //       context: Get.context!,
      //       title: "Error",
      //       message: l.message.toString(),
      //       backgroundColor: ColorPalette.red)
      //   );
      // }

      update();
    }
  }

}