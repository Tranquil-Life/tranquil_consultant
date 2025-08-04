import 'package:tl_consultant/features/wallet/domain/entities/stripe_account.dart';

class StripeAccountModel extends StripeAccount {
  StripeAccountModel(
      {required super.id,
      required super.email,
      required super.phone,
      required super.firstName,
      required super.lastName,
      required super.dayOfBirth,
      required super.monthOfBirth,
      required super.yearOfBirth,
      required super.homeAddress,
      required super.city,
      required super.state,
      required super.businessWebsite,
      required super.postalCode,
      required super.accountNumber,
      required super.routingNumber,
      required super.holderName,
      required super.ssn,
      required super.frontOfID,
      required super.backOfID,
      required super.acceptedTOS});
}
