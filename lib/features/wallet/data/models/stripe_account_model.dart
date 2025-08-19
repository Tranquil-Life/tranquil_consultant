class StripeAccountModel {
  final String? id;
  final String? object;
  final BusinessProfile? businessProfile;
  final String? businessType;
  final Capabilities? capabilities;
  final bool? chargesEnabled;
  final Company? company;
  final Controller? controller;
  final String? country;
  final int? created;
  final String? defaultCurrency;
  final bool? detailsSubmitted;
  final String? email;
  final ExternalAccounts? externalAccounts;
  final Requirements? futureRequirements;
  final Individual? individual;
  final List<dynamic>? metadata;
  final bool? payoutsEnabled;
  final Requirements? requirements;
  final Settings? settings;
  final TosAcceptance? tosAcceptance;
  final String? type;

  StripeAccountModel({
    this.id,
    this.object,
    this.businessProfile,
    this.businessType,
    this.capabilities,
    this.chargesEnabled,
    this.company,
    this.controller,
    this.country,
    this.created,
    this.defaultCurrency,
    this.detailsSubmitted,
    this.email,
    this.externalAccounts,
    this.futureRequirements,
    this.individual,
    this.metadata,
    this.payoutsEnabled,
    this.requirements,
    this.settings,
    this.tosAcceptance,
    this.type,
  });

  factory StripeAccountModel.fromJson(Map<String, dynamic> json) =>
      StripeAccountModel(
        id: json["id"],
        object: json["object"],
        businessProfile: BusinessProfile.fromJson(json["business_profile"]),
        businessType: json["business_type"],
        capabilities: Capabilities.fromJson(json["capabilities"]),
        chargesEnabled: json["charges_enabled"],
        company: Company.fromJson(json["company"]),
        controller: Controller.fromJson(json["controller"]),
        country: json["country"],
        created: json["created"],
        defaultCurrency: json["default_currency"],
        detailsSubmitted: json["details_submitted"],
        email: json["email"],
        externalAccounts: ExternalAccounts.fromJson(json["external_accounts"]),
        futureRequirements: Requirements.fromJson(json["future_requirements"]),
        individual: Individual.fromJson(json["individual"]),
        metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
        payoutsEnabled: json["payouts_enabled"],
        requirements: Requirements.fromJson(json["requirements"]),
        settings: Settings.fromJson(json["settings"]),
        tosAcceptance: TosAcceptance.fromJson(json["tos_acceptance"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "business_profile": businessProfile?.toJson(),
        "business_type": businessType,
        "capabilities": capabilities?.toJson(),
        "charges_enabled": chargesEnabled,
        "company": company?.toJson(),
        "controller": controller?.toJson(),
        "country": country,
        "created": created,
        "default_currency": defaultCurrency,
        "details_submitted": detailsSubmitted,
        "email": email,
        "external_accounts": externalAccounts?.toJson(),
        "future_requirements": futureRequirements?.toJson(),
        "individual": individual?.toJson(),
        "metadata": List<dynamic>.from(metadata!.map((x) => x)),
        "payouts_enabled": payoutsEnabled,
        "requirements": requirements?.toJson(),
        "settings": settings?.toJson(),
        "tos_acceptance": tosAcceptance?.toJson(),
        "type": type,
      };
}

/// Business Profile
class BusinessProfile {
  final String? mcc;
  final String? url;

  BusinessProfile({this.mcc, this.url});

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      BusinessProfile(
        mcc: json["mcc"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "mcc": mcc,
        "url": url,
      };
}

/// Capabilities
class Capabilities {
  final String cardPayments;
  final String transfers;

  Capabilities({
    required this.cardPayments,
    required this.transfers,
  });

  factory Capabilities.fromJson(Map<String, dynamic> json) => Capabilities(
        cardPayments: json["card_payments"],
        transfers: json["transfers"],
      );

  Map<String, dynamic> toJson() => {
        "card_payments": cardPayments,
        "transfers": transfers,
      };
}

/// Company
class Company {
  final Address address;
  final Verification verification;

  Company({required this.address, required this.verification});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        address: Address.fromJson(json["address"]),
        verification: Verification.fromJson(json["verification"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "verification": verification.toJson(),
      };
}

class Address {
  final String city;
  final String country;
  final String line1;
  final String? line2;
  final String postalCode;
  final String state;

  Address({
    required this.city,
    required this.country,
    required this.line1,
    this.line2,
    required this.postalCode,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

/// Verification
class Verification {
  final Document document;

  Verification({required this.document});

  factory Verification.fromJson(Map<String, dynamic> json) => Verification(
        document: Document.fromJson(json["document"]),
      );

  Map<String, dynamic> toJson() => {
        "document": document.toJson(),
      };
}

class Document {
  final String? front;
  final String? back;

  Document({this.front, this.back});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        front: json["front"],
        back: json["back"],
      );

  Map<String, dynamic> toJson() => {
        "front": front,
        "back": back,
      };
}

/// Controller
class Controller {
  final String type;

  Controller({required this.type});

  factory Controller.fromJson(Map<String, dynamic> json) => Controller(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

/// External Accounts
class ExternalAccounts {
  final List<BankAccount> data;

  ExternalAccounts({required this.data});

  factory ExternalAccounts.fromJson(Map<String, dynamic> json) =>
      ExternalAccounts(
        data: List<BankAccount>.from(
            json["data"].map((x) => BankAccount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BankAccount {
  final String id;
  final String bankName;
  final String country;
  final String currency;
  final String last4;
  final String accountHolderName;

  BankAccount(
      {required this.id,
      required this.bankName,
      required this.country,
      required this.currency,
      required this.last4,
      required this.accountHolderName});

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        bankName: json["bank_name"],
        country: json["country"],
        currency: json["currency"],
        last4: json["last4"],
        accountHolderName: json["account_holder_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_name": bankName,
        "country": country,
        "currency": currency,
        "last4": last4,
        "account_holder_name": accountHolderName
      };
}

/// Requirements (reused multiple times)
class Requirements {
  final List<dynamic> currentlyDue;

  Requirements({required this.currentlyDue});

  factory Requirements.fromJson(Map<String, dynamic> json) => Requirements(
        currentlyDue: List<dynamic>.from(json["currently_due"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "currently_due": List<dynamic>.from(currentlyDue.map((x) => x)),
      };
}

/// Individual
class Individual {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Address address;
  final DateOfBirth dateOfBirth;

  Individual(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.address,
      required this.dateOfBirth});

  factory Individual.fromJson(Map<String, dynamic> json) => Individual(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      address: Address.fromJson(json["address"]),
      dateOfBirth: DateOfBirth.fromJson(json['dob']));

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "address": address.toJson(),
      };
}

class DateOfBirth {
  final int day;
  final int month;
  final int year;

  DateOfBirth({required this.day, required this.month, required this.year});

  factory DateOfBirth.fromJson(Map<String, dynamic> json) =>
      DateOfBirth(day: json['day'], month: json['month'], year: json['year']);

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
      };
}

/// Settings
class Settings {
  final Dashboard dashboard;

  Settings({required this.dashboard});

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        dashboard: Dashboard.fromJson(json["dashboard"]),
      );

  Map<String, dynamic> toJson() => {
        "dashboard": dashboard.toJson(),
      };
}

class Dashboard {
  final String displayName;
  final String timezone;

  Dashboard({required this.displayName, required this.timezone});

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        displayName: json["display_name"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "display_name": displayName,
        "timezone": timezone,
      };
}

/// TosAcceptance
class TosAcceptance {
  final int date;
  final String ip;

  TosAcceptance({required this.date, required this.ip});

  factory TosAcceptance.fromJson(Map<String, dynamic> json) => TosAcceptance(
        date: json["date"],
        ip: json["ip"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "ip": ip,
      };
}
