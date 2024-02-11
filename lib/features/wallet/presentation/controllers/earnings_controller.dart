import 'dart:async';

import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

class EarningsController extends GetxController{
  static EarningsController instance = Get.find();

  final repo = WalletRepositoryImpl();

  var balance = 0.00.obs;
  var withdrawn = 0.00.obs;
  var availableForWithdrawal = 0.00.obs;

  Future getEarningsInfo() async{
    var result =  await repo.getWallet();
    if(result.isRight()){
      result.map((r){
        Earnings earnings = EarningsModel.fromJson(r['data']);
        balance.value = earnings.balance;
        withdrawn.value = earnings.withdrawn;
        availableForWithdrawal.value = earnings.availableForWithdrawal;
      });
    }else{
      result.leftMap((l) => CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message!,
          backgroundColor: ColorPalette.red
      ));
    }
  }

  @override
  void onInit() {
    //getEarningsInfo();
    super.onInit();
  }
}