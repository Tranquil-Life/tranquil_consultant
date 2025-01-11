
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
    super.videoIntroUrl,
    super.specialties,
    required super.emailVerifiedAt,
    // required super.hasAnsweredQuestions,
    // required super.usesBitmoji,
    super.birthDate,
    super.bio,
    // super.gender,
    // super.staffId,
    // super.companyName,
    super.totalMeetings,
    super.totalClients,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}