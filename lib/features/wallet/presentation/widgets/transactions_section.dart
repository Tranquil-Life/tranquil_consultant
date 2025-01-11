part of 'transaction_item.dart';

class TransactionsSection extends StatefulWidget {
  const TransactionsSection({super.key});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  TransactionsController trnxController = Get.put(TransactionsController());

  NumberFormat? formatCurrency;

  @override
  void initState() {
    trnxController.scrollController = ScrollController();
    trnxController.scrollController.addListener(() {
      trnxController.loadMoreTransactions();
    });
    trnxController
        .loadFirstTransactions(); // Load the first set of transactions

    formatCurrency = NumberFormat.currency(locale: "en_NG", symbol: '₦');

    trnxController.transactions.sort((a, b) {
      final dateA = a.createdAt;
      final dateB = b.createdAt;
      return dateB.compareTo(dateA);
    });

    super.initState();
  }

  String currentDate = '';

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
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
                      color: trnxController.transactions.isEmpty
                          ? ColorPalette.green[200]
                          : ColorPalette.green),
                ),
              ],
            ),
            trnxController.transactions.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: displayHeight(context)/25),
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
                : Expanded(
                    child: ListView.builder(
                        itemCount: trnxController.transactions.length,
                        controller: trnxController.scrollController,
                        itemBuilder: (context, index) {
                          var e = trnxController.transactions[index];
                          final amount = e.amount;
                          final isCredit = e.isCredit;
                          final createdAt = e.createdAt;
                          final formattedDate = createdAt.formatted;

                          return TransactionItem(
                              amount: formatCurrency!.format(amount),
                              time: formattedDate,
                              withdrawn: isCredit);
                        }))
          ],
        ));
  }
}
