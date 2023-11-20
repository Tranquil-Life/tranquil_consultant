import 'package:get/get.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

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
    User therapist = UserModel.fromJson(userDataStore.user);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${therapist.authToken}',
    };
    var result = await httpClient.get(subPath, query: parameters, headers: headers);
    return result;
  }

  Future postReq(String subPath, {dynamic body}) async {
    User therapist = UserModel.fromJson(userDataStore.user);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${therapist.authToken}',
    };
    var result = await httpClient.post(subPath, body: body, headers: headers);

    return result;
  }

  Future deleteReq(String subPath, {dynamic body}) async {
    var result = await httpClient.delete(subPath);

    return result;
  }

}