import 'dart:io';

import 'package:tl_consultant/core/domain/query_params.dart';

part 'create_stripe_account.g.dart';

class CreateStripeAccount extends QueryParams{
  final int? id;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final int? dayOfBirth;
  final int? monthOfBirth;
  final int? yearOfBirth;
  final String? homeAddress;
  final String? city;
  final String? state;
  final String? businessWebsite;
  final String? postalCode;
  final String? accountNumber;
  final String? routingNumber;
  final String? holderName;
  final String? ssn;
  final File? frontOfID;
  final File? backOfID;
  final bool? acceptedTOS;

  CreateStripeAccount(
      { this.id,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.dayOfBirth,
      required this.monthOfBirth,
      required this.yearOfBirth,
      required this.homeAddress,
      required this.city,
      required this.state,
      required this.businessWebsite,
      required this.postalCode,
      required this.accountNumber,
      required this.routingNumber,
      required this.holderName,
      required this.ssn,
      required this.frontOfID,
      required this.backOfID,
      required this.acceptedTOS});

  @override
  Map<String, dynamic> toJson() => _$StripeAccountToJson(this);
}
