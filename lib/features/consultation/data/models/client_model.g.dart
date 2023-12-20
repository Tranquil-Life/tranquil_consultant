part of 'client_model.dart';

ClientModel _$ClientModelFromJson(Map<String, dynamic> json)=>
    ClientModel(
        id: 0,
        avatarUrl: json['avatar_url'] == null  ? "" : json['avatar_url'].toString(),
        displayName: json['display_name'] ?? "",
        usesBitmoji: json['uses_bitmoji'] ?? false
        );