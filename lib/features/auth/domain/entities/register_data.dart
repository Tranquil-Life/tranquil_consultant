import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class RegisterData extends QueryParams {
  RegisterData();

  String email = '';
  String password = '';
  String phone = '';
  String firstName = '';
  String lastName = '';
  String birthDate = '';
  String cvUrl='';
  String identityUrl = '';
  String currentLocation = '';
  String linkedinUrl = '';
  String yearsOfExperience = '';
  String employmentStatus = '';
  List<String> languages = [];
  List<String> expertise = [];

  @override
  Map<String, dynamic> toJson()=><String, dynamic>{
    'email': email.isEmpty ? AuthController.instance.emailTEC.text : email,
    'password': password.isEmpty ? AuthController.instance.passwordTEC.text : password,
    'phone': phone,
    'f_name': firstName,
    'l_name': lastName,
    'birth_date': birthDate,
    'cv_url': cvUrl,
    'identity_front_url': identityUrl,
    'location': currentLocation.isEmpty ? AuthController.instance.currLocationTEC.text : currentLocation,
    'linkedin_url': linkedinUrl,
    'specialties': expertise.isEmpty ? AuthController.instance.areaOfExpertiseTEC.text.split(', ') : expertise,
    'years': yearsOfExperience.isEmpty ? AuthController.instance.yearsOfExperienceTEC.text : yearsOfExperience,
    "languages": AuthController.instance.languagesArr,
    "employment_status": "employed"
  };
}
