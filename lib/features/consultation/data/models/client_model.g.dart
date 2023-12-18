part of 'client_model.dart';

ClientModel _$ClientModelFromJson(Map<String, dynamic> json)=>
    ClientModel(
        id: json['id'] as int,
        avatarUrl: json['avatar_url'] ?? "",
        displayName: json['display_name'] ?? "",
        usesBitmoji: json['uses_bitmoji'] ?? false
        );