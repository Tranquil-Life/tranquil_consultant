class StripeTransaction {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String? status;
  final String destination;
  final String created;

  StripeTransaction(
      {required this.id,
      required this.type,
      required this.amount,
      required this.currency,
      required this.status,
      required this.destination,
      required this.created});

  /// Factory constructor to create a Transaction from JSON
  factory StripeTransaction.fromJson(Map<String, dynamic> json) {
    return StripeTransaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      status: json['status'],
      destination: json['destination'] ?? '',
      created: json['created'] ?? '',
    );
  }

  /// Convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'status': status,
      'destination': destination,
      'created': created,
    };
  }
}
