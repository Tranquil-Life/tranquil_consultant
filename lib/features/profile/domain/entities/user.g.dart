part of 'user.dart';

Map<String, dynamic> _$UserToJson(User instance) =><String, dynamic>{
  'avatar_url': instance.avatarUrl,
  'id': instance.id,
  'f_name': instance.firstName,
  'l_name': instance.lastName,
  'email': instance.email,
  'phone': instance.phoneNumber,
  'birth_date': instance.birthDate,
  'gender': instance.gender,
  'staff_id': instance.staffId,
  'company_name': instance.companyName,
  'uses_bitmoji': instance.usesBitmoji,
  'is_verified': instance.isVerified,
};