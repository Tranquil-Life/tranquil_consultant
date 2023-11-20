import 'dart:async';

import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/wallet/data/models/earnings_model.dart';
import 'package:tl_consultant/features/wallet/data/repos/earnings_repo.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

class EarningsController extends GetxController{
  static EarningsController instance = Get.find();

  final repo = EarningsRepoImpl();

  var netIncome = 0.00.obs;
  var withdrawn = 0.00.obs;
  var availableForWithdrawal = 0.00.obs;
  var pendingClearance = 0.00.obs;
  var expectedEarnings = 0.00.obs;

  final earningsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get earningStream => earningsStreamController.stream;

  Future getEarningsInfo() async{
    var netIncome = 0.00;
    var withdrawn = 0.00;
    var availableForWithdrawal = 0.00;
    var pendingClearance = 0.00;
    var expectedEarnings = 0.00;

    var result =  await repo.getInfo();
    if(result.isRight()){
      result.map((r){
        Earnings earnings = EarningsModel.fromJson(r);

        netIncome = earnings.netInCome;
        withdrawn = earnings.withdrawn;
        availableForWithdrawal = earnings.availableForWithdrawal;
      });

      Map<String, dynamic> values = {
        "net_income": netIncome,
        "withdrawn": withdrawn,
        "available_for_withdrawal": availableForWithdrawal,
      };

      earningsStreamController.sink.add(values);
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
    getEarningsInfo();
    super.onInit();
  }
}