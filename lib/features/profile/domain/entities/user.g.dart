part of 'user.dart';

Map<String, dynamic> _$UserToJson(User instance) =><String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'video_intro': instance.videoIntroUrl,
  'f_name': instance.firstName,
  'l_name': instance.lastName,
  'phone': instance.phoneNumber,
  'bio': instance.bio,
  'gender': instance.gender,
  'location': instance.location,
  'time_zone': instance.timezone,
  'specialties': instance.specialties,
  'auth_token': instance.authToken,
  // 'company_name': instance.companyName,
  // 'uses_bitmoji': instance.usesBitmoji,
};