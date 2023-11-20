part of 'transaction_item.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

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

  // List<Map<String, dynamic>> transactionsWithSameUpdatedAt = [];
  // List<Map<String, dynamic>> transactionsWithoutSameUpdatedAt = [];
  // List filteredTrx = [];


  @override
  void initState() {
    //filterTrx();
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
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Transactions",
                    style: TextStyle(
                        fontFamily: AppFonts.josefinSansBold,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFonts.defaultSize
                    ),
                  ),
                  Icon(
                      Icons.download_for_offline,
                      color: ColorPalette.green)
                ],
              ),

              Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Last 30 days",
                    style: TextStyle(
                        fontFamily: AppFonts.josefinSansBold,
                        fontWeight: FontWeight.w700,
                        fontSize: AppFonts.defaultSize
                    ),),
                  GestureDetector(
                    onTap: (){
                      //filterTrx();
                      //setState(() {});
                    },
                    child: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 50,
                        color: ColorPalette.green),
                  )
                ],
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: transactions.length,
                      itemBuilder: (context,index){
                        final transaction = transactions[index];
                        // Access transaction attributes and create widgets to display the data
                        final amount = transaction['amount'];
                        final isCredit = transaction['is_credit'];
                        final status = transaction['status'];
                        final updatedAt = DateTime.parse(transaction['updated_at']);
                        final formattedDate = updatedAt.formatDate;

                        if (formattedDate != currentDate) {
                          currentDate = formattedDate;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 32),
                              Text(formattedDate,
                                style: TextStyle(fontSize: 16),),
                              Divider(color: Colors.grey,),
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("${isCredit ==false ? "-" :""}$amount", style: TextStyle(fontSize: AppFonts.defaultSize),),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        width: 120,
                                        height: 31,
                                        decoration: BoxDecoration(
                                            color: !isCredit ? ColorPalette.red.shade400: ColorPalette.green,
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(width: 2, color: !isCredit ? ColorPalette.red : ColorPalette.green),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
                                            ]
                                        ),
                                        child: Center(
                                          child: Text(
                                              isCredit ==false ? "Withdrawn" : "Received",
                                              style: const TextStyle(fontSize: AppFonts.defaultSize, color: Colors.white)
                                          ),
                                        )
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(updatedAt.formattedTime, style: TextStyle(fontSize: AppFonts.defaultSize)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                        else {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text("${isCredit ==false ? "-" :""}$amount", style: TextStyle(fontSize: AppFonts.defaultSize),),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 120,
                                      height: 31,
                                      decoration: BoxDecoration(
                                          color: isCredit ==false ? ColorPalette.red.shade400: ColorPalette.green,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(width: 2, color: isCredit ==false  ? ColorPalette.red : ColorPalette.green),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
                                          ]
                                      ),
                                      child: Center(
                                        child: Text(
                                            !isCredit ? "Withdrawn" : "Received",
                                            style: const TextStyle(fontSize: AppFonts.defaultSize, color: Colors.white)
                                        ),
                                      )
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(updatedAt.formattedTime, style: TextStyle(fontSize: AppFonts.defaultSize)),
                                  ),
                                ),
                              ],
                            ),
                          );
                          return ListTile(
                            title: Text('Amount: $amount'),
                            subtitle: Text('Status: $status'),
                            trailing: isCredit ? Icon(Icons.add) : Icon(Icons.remove),
                          );
                        }
                        // return Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     SizedBox(height: 24),
                        //     Text(formattedDate,
                        //       style: TextStyle(fontSize: 16),),
                        //     Divider(),
                        //     EachTransaction(
                        //         amount:amount.toString(), time: updatedAt.formattedTime, withdrawn: isCredit ? false : true),
                        //   ],
                        // );
                      })
                ],
              ),
            ),
          )

        ],
      ),
    );
  }



}

