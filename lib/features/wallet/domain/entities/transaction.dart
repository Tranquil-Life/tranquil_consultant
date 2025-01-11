class Transaction {
  final int id;
  final int userId;
  final String amount;
  final bool isCredit;
  final String status;
  final String? trnRef;
  final String? accountNumber;
  final String? bankName;
  final String? accountName;
  final String? currency;
  final String? description;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.isCredit,
    required this.status,
    this.trnRef,
    this.accountNumber,
    this.bankName,
    this.accountName,
    this.currency,
    this.description,
    required this.createdAt,
  });

  // From JSON to Transaction
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      isCredit: json['is_credit'] == 1, // assuming 1 is true, 0 is false
      status: json['status'],
      trnRef: json['trn_ref'],
      accountNumber: json['account_number'],
      bankName: json['bank_name'],
      accountName: json['account_name'],
      currency: json['currency'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']), // Assuming 'created_at' is a string in ISO 8601 format
    );
  }

  // From Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'is_credit': isCredit ? 1 : 0, // convert boolean to 1 or 0
      'status': status,
      'trn_ref': trnRef,
      'account_number': accountNumber,
      'bank_name': bankName,
      'account_name': accountName,
      'currency': currency,
      'description': description,
      'created_at': createdAt.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}
