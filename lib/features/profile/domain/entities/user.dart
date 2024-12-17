import 'package:json_annotation/json_annotation.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: true)
class User {
  @JsonKey(name: 'id')
  final int? id;

  final String? email;

  @JsonKey(name: 'f_name')
  final String firstName;

  @JsonKey(name: 'l_name')
  final String lastName;

  @JsonKey(name: 'phone')
  final String phoneNumber;

  @JsonKey(name: 'auth_token')
  final String? authToken;

  final bool? usesBitmoji;

  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'bio')
  final String bio;
  final String? timezone;
  final List? specialties;
  @JsonKey(name: 'email_verified_at', fromJson: isVerifiedFromJson)
  final DateTime? emailVerifiedAt;
  final String? birthDate, gender, staffId, companyName;

  User({
    this.id,
    this.email,
    this.emailVerifiedAt,
    this.firstName = "",
    this.lastName = "",
    this.phoneNumber = "",
    this.bio = "",
    this.specialties,
    this.authToken,
    this.usesBitmoji,
    this.birthDate,
    this.gender,
    this.staffId,
    this.companyName,
    this.avatarUrl = '',
    this.location = "",
    this.timezone,
  });



  Map<String, dynamic> toJson() => _$UserToJson(this);
}

isVerifiedFromJson(dynamic jsonValue) => jsonValue != null;
