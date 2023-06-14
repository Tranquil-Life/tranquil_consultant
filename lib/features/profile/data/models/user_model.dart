
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

part 'user_model.g.dart';

class UserModel extends User{
  UserModel({
    //super.email,
    required super.firstName,
    required super.lastName,
    super.id,
    required super.authToken,
    //required super.phoneNumber,
    //required super.usesBitmoji,
    // required super.isVerified,
    // required super.hasAnsweredQuestions,
    // required super.usesBitmoji,
    // super.avatarUrl,
    // super.birthDate,
    // super.gender,
    // super.staffId,
    // super.companyName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}