part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  //email: json['email'] as String ?? '',
  firstName: json['f_name'] ?? '',
  lastName: json['l_name'] ?? '',
  id: json['id'],
  authToken: json['auth_token'],
  //phoneNumber: json['phone'] as String,
  emailVerifiedAt: json['email_verified_at'],
  // hasAnsweredQuestions: json['has_answered_questions'] as bool? ?? false,
  //usesBitmoji: json['uses_bitmoji'] as bool,
  avatarUrl: json['avatar_url'] ?? '',
  birthDate: json['birth_date'] ?? '',
  bio: json['bio'] ?? '',
  // gender: json['gender'] as String ?? '',
  // staffId: json['staff_id'] as String ?? '',
  // companyName: json['company_name'] as String?,

);