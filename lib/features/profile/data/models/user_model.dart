
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

part 'user_model.g.dart';

class UserModel extends User{
  UserModel({
    super.id,
    super.email,
    required super.firstName,
    required super.lastName,
    required super.authToken,
    super.avatarUrl,
    required super.phoneNumber,
    //required super.usesBitmoji,
    required super.emailVerifiedAt,
    // required super.hasAnsweredQuestions,
    // required super.usesBitmoji,
    super.birthDate,
    super.bio,
    // super.gender,
    // super.staffId,
    // super.companyName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}