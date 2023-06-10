import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: true)

class User {
  @JsonKey(name: 'id')
  final int? id;

  final String? email;

  @JsonKey(name: 'display_name')
  String? displayName;

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

  @JsonKey(name: 'email_verified_at', fromJson: isVerifiedFromJson)
  final bool? isVerified;
  final String? birthDate, gender, staffId, companyName;


  User({
    this.id,
    this.email,
    this.isVerified,
    this.firstName = "",
    this.lastName = "",
    this.phoneNumber = "",
    this.displayName= "",
    this.authToken,
    this.usesBitmoji,
    this.birthDate,
    this.gender,
    this.staffId,
    this.companyName,
    this.avatarUrl='',
  });

  User copyWith({
    String? fname,
    int? id,
    String? phoneNumber,
    String? displayName,
    String? birthDate,
  }) =>
      User(
          firstName: fname ?? firstName,
          lastName: lastName,
          id: id ?? this.id,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          displayName: displayName ?? this.displayName,
          birthDate: birthDate ?? this.birthDate,
          usesBitmoji: usesBitmoji);


  Map<String, dynamic> toJson() => _$UserToJson(this);
}


isVerifiedFromJson(dynamic jsonValue) => jsonValue != null;

