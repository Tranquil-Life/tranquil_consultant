import 'package:tl_consultant/app/domain/query_params.dart';

class RegisterData extends QueryParams {
  RegisterData();

  String email = '';
  String password = '';
  String phone = '';
  String displayName = '';
  String firstName = '';
  String lastName = '';
  String birthDate = '';
  String cvUrl='';
  String identityUrl = '';
  String currentLocation = '';
  String linkedinUrl = '';

  @override
  Map<String, dynamic> toJson()=><String, dynamic>{
    'email': email,
    'password': password,
    'phone': phone,
    'display_name': displayName,
    'f_name': firstName,
    'l_name': lastName,
    'birth_date': birthDate,
    'cv_url': cvUrl,
    'identity_front_url': identityUrl,
    'location': currentLocation,
    'linkedin_url': linkedinUrl,
  };
}
