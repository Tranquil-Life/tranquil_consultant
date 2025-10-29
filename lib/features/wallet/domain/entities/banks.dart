import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

class Banks{
  final dashboardController = DashboardController.instance;

  static var us = [
    "Chase Bank",
    "Wells Fargo",
    "Bank of America",
    "U.S. Bank",
    "PNC Bank",
    "Citibank"
  ];

  Future<List<String>> fetchNigerianBanks() async {
    final response = await ApiService().dio.get("https://nigerianbanks.xyz");
    List data = response.data;
    return data.map((e) => Bank.fromJson(e).name).toList();
  }

  static var ng = [
    ""
  ];

  static var uk = [
    ""
  ];

  static var gh = [
    ""
  ];

  static var ca = [
    ""
  ];

  static var za = [
    ""
  ];

  Future<List<String>> getBanks() async{
    switch(dashboardController.country.value){
      case "United States":
        return us;
      case "Nigeria":
        ng = await fetchNigerianBanks();
        return ng;
      case "United Kingdom":
        return uk;
      case "Ghana":
        return gh;
      case "Canada":
        return ca;
      case "South Africa":
        return za;
      default:
        return [];
    }

  }
}

class Bank {
  final String name;
  final String code;
  final String logo;

  Bank({required this.name, required this.code, required this.logo});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'],
      code: json['code'],
      logo: json['logo'],
    );
  }
}

