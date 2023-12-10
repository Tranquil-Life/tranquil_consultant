class Transaction {
  final int amount;
  final String refId;
  final DateTime date;

  Transaction({required this.amount, required this.refId, required this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      amount: json['amount'],
      refId: json['trn_ref'],
      date: DateTime.parse(json['updated_at'].toString())
  );
}