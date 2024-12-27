
import 'package:get/get.dart';

class VerificationController extends GetxController{
  RxBool? isConfirmed;
  Future verifyToken(String token) async{
    if (token == '222222') {
      isConfirmed = true.obs; // Set the observable value to true.
    } else {
      isConfirmed = false.obs; // Set the observable value to false.
    }

    print(isConfirmed?.value);
  }
}