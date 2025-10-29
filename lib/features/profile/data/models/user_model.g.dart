part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'],
  email: json['email'],
  firstName: json['f_name'] ?? '',
  lastName: json['l_name'] ?? '',
  authToken: json['auth_token'],
  phoneNumber: json['phone'] ?? '',
  emailVerifiedAt: json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at']) : null,
  avatarUrl: json['avatar_url'] ?? '',
  birthDate: json['birth_date'],
  bio: json['bio'] ?? '',
  videoIntroUrl: json['video_intro'] ?? '',
  specialties: json['specialties'] ?? [],
  totalMeetings: json['meetings_count'] ?? 0,
  totalClients: json['clients_count'] ?? 0,
  stripeAccountId: json['stripe_account_id'] ?? null
  // gender: json['gender'] as String ?? '',
  // staffId: json['staff_id'] as String ?? '',
  // companyName: json['company_name'] as String?,

);