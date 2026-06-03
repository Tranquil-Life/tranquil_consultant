import 'package:tl_consultant/features/auth/data/models/additional_license_model.dart';

class TherapistApplication {
  String firstName;
  String lastName;
  String email;
  String phone;
  String profession;
  String homeStateLicense;
  String licenseNumber;
  String? npiNumber;
  String status;
  List<AdditionalLicense> additionalLicenses;

  TherapistApplication({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profession,
    required this.homeStateLicense,
    required this.licenseNumber,
    this.npiNumber,
    this.status = 'pending',
    this.additionalLicenses = const [],
  });

  factory TherapistApplication.fromJson(
      Map<String, dynamic> json,
      ) {
    return TherapistApplication(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profession: json['profession'] ?? '',
      homeStateLicense: json['home_state_license'] ?? '',
      licenseNumber: json['license_number'] ?? '',
      npiNumber: json['npi_number'],
      status: json['status'] ?? 'pending',
      additionalLicenses:
      (json['additional_licenses'] as List<dynamic>? ?? [])
          .map(
            (e) => AdditionalLicense.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profession': profession,
      'home_state_license': homeStateLicense,
      'license_number': licenseNumber,
      'npi_number': npiNumber,
      'status': status,
      'additional_licenses':
      additionalLicenses.map((e) => e.toJson()).toList(),
    };
  }
}