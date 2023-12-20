import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';

part 'client_model.g.dart';

@JsonSerializable(createFactory: true)
class ClientModel extends ClientUser {
  ClientModel({
    required super.id,
    required super.avatarUrl,
    required super.usesBitmoji,
    required super.displayName
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => _$ClientModelFromJson(json);
}