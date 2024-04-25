part of 'transaction_item.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  // List<Map<String, dynamic>> transactions = [];

  List<Map<String, dynamic>> transactions = [
    {
      "id": 1,
      "user_id": 2,
      "amount": 200,
      "is_credit": false,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": "0138407224775",
      "bank_name": "UBA Bank",
      "account_name": "Applegate Johnson",
      "currency": "N",
      "updated_at": "2023-01-31T14:45:32.000000Z"
    },
    {
      "id": 2,
      "user_id": 2,
      "amount": 160,
      "is_credit": true,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": null,
      "bank_name": null,
      "account_name": null,
      "currency": "N",
      "updated_at": "2023-08-02T14:45:32.000000Z"
    },
    {
      "id": 3,
      "user_id": 2,
      "amount": 600,
      "is_credit": true,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": null,
      "bank_name": null,
      "account_name": null,
      "currency": "N",
      "updated_at": "2023-01-31T14:45:32.000000Z"
    },
    {
      "id": 4,
      "user_id": 2,
      "amount": 720,
      "is_credit": true,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": null,
      "bank_name": null,
      "account_name": null,
      "currency": "N",
      "updated_at": "2023-02-01T14:45:32.000000Z"
    },
    {
      "id": 5,
      "user_id": 2,
      "amount": 290,
      "is_credit": true,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": null,
      "bank_name": null,
      "account_name": null,
      "currency": "N",
      "updated_at": "2023-02-07T14:45:32.000000Z"
    },
    {
      "id": 6,
      "user_id": 2,
      "amount": 790,
      "is_credit": true,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": null,
      "bank_name": null,
      "account_name": null,
      "currency": "N",
      "updated_at": "2023-02-07T14:45:32.000000Z"
    },
    {
      "id": 7,
      "user_id": 2,
      "amount": 580,
      "is_credit": true,
      "status": "successful",
      "trn_ref": "vnjiv94th",
      "account_number": null,
      "bank_name": null,
      "account_name": null,
      "currency": "N",
      "updated_at": "2023-02-01T14:45:32.000000Z"
    },
  ];
  NumberFormat? formatCurrency;

  @override
  void initState() {
    formatCurrency = NumberFormat.currency(locale: "en_NG", symbol: '₦');

    transactions.sort((a, b) {
      final dateA = DateTime.parse(a['updated_at']);
      final dateB = DateTime.parse(b['updated_at']);
      return dateB.compareTo(dateA);
    });

    super.initState();
  }

  String currentDate = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Transactions",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "See all",
              style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  fontFamily: AppFonts.josefinSansRegular,
                  fontWeight: FontWeight.bold,
                  color: transactions.isEmpty
                      ? ColorPalette.green[200]
                      : ColorPalette.green),
            ),
          ],
        ),
        transactions.isEmpty
            ? Container(
                margin: EdgeInsets.only(top: 48),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: ColorPalette.green[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "\$",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: AppFonts.josefinSansBold,
                            color: ColorPalette.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("You don't have any transactions",
                        style: TextStyle(fontSize: AppFonts.defaultSize))
                  ],
                ))
            : SizedBox(
                height: 220,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      final transaction = transactions[index];
                      // Access transaction attributes and create widgets to display the data
                      final amount = transaction['amount'];
                      final isCredit = transaction['is_credit'];
                      // final status = transaction['status'];
                      final updatedAt =
                          DateTime.parse(transaction['updated_at']);
                      final formattedDate = updatedAt.formatted;
                      return TransactionItem(
                          amount: formatCurrency!.format(amount),
                          time: formattedDate,
                          withdrawn: isCredit);
                    }))
      ],
    );
  }
}
