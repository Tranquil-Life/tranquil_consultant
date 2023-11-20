import 'package:get/get.dart';
import 'package:tl_consultant/features/wallet/data/repos/wallet_repo_impl.dart';

class WalletController extends GetxController{
  static WalletController instance = Get.find();
  WalletRepositoryImpl repo = WalletRepositoryImpl();

}