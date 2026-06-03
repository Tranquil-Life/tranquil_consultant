class AdditionalLicense {
  String state;
  String licenseNumber;

  AdditionalLicense({
    required this.state,
    required this.licenseNumber,
  });

  factory AdditionalLicense.empty() {
    return AdditionalLicense(
      state: '',
      licenseNumber: '',
    );
  } //We need this to create an empty license object when the user wants to add a new license. This way we can easily add a new license to the list of additional licenses without having to worry about null values.

  factory AdditionalLicense.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdditionalLicense(
      state: json['state'] ?? '',
      licenseNumber: json['license_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'license_number': licenseNumber,
    };
  }
}