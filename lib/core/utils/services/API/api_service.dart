import 'package:get/get.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class ApiData {
  final int? statusCode;
  final dynamic data;

  const ApiData(this.data, this.statusCode);
}

class ApiService extends GetConnect {
  Future getReq(
    String subPath, {
    Map<String, dynamic>? parameters,
  }) async {
    final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${DashboardController.instance.authToken.value}',
  };
    var result = await httpClient.get(subPath, query: parameters, headers: headers);
    return result;
  }

  Future postReq(String subPath, {dynamic body}) async {
    if(DashboardController.instance.authToken.value.isNotEmpty){
      print(DashboardController.instance.authToken.value);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DashboardController.instance.authToken.value}',
      };
      var result = await httpClient.post(subPath, body: body, headers: headers);
      return result;
    }else{
      print("LOCAL_STORAGE: ${userDataStore.user['auth_token']}");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userDataStore.user['auth_token']}',
      };
      var result = await httpClient.post(subPath, body: body, headers: headers);
      return result;
    }

  }

  Future deleteReq(String subPath, {dynamic body}) async {
    var result = await httpClient.delete(subPath);

    return result;
  }

}


