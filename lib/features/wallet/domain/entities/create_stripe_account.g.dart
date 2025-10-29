part of 'create_stripe_account.dart';

Map<String, dynamic> _$StripeAccountToJson(CreateStripeAccount instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'dob_day': instance.dayOfBirth,
      'dob_month': instance.monthOfBirth,
      'dob_year': instance.yearOfBirth,
      'address_line1': instance.homeAddress,
      'city': instance.city,
      'state': instance.state,
      'business_website': instance.businessWebsite,
      'postal_code': instance.postalCode,
      'account_number': instance.accountNumber,
      'routing_number': instance.routingNumber,
      'holder_name': instance.holderName,
      'id_number': instance.ssn,
      'front': instance.frontOfID,
      'back': instance.backOfID,
      'tos': instance.acceptedTOS,
    };
