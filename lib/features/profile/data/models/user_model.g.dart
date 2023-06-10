part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  //email: json['email'] as String ?? '',
  //firstName: json['f_name'] as String ?? '',
  //lastName: json['l_name'] as String ?? '',
  id: json['id'] as int?,
  displayName: json['display_name'] ?? "",
  authToken: json['auth_token'],
  //phoneNumber: json['phone'] as String,
  // isVerified: json['is_verified'] as bool? ?? false,
  // hasAnsweredQuestions: json['has_answered_questions'] as bool? ?? false,
  //usesBitmoji: json['uses_bitmoji'] as bool,
  // avatarUrl: json['avatar_url'] as String? ?? '',
  // birthDate: json['birth_date'] as String ?? '',
  // gender: json['gender'] as String ?? '',
  // staffId: json['staff_id'] as String ?? '',
  // companyName: json['company_name'] as String?,
);