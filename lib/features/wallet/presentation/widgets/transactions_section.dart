part of 'transaction_item.dart';

class TransactionsSection extends StatefulWidget {
  const TransactionsSection({super.key});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  final trnxController = TransactionsController.instance; // reuse, not put
  NumberFormat? formatCurrency;

  DateTime parseBackendUtc(String s) {
    return DateTime.parse('${s.replaceFirst(' ', 'T')}Z').toLocal();
  }

  @override
  void initState() {
    super.initState();
    formatCurrency = NumberFormat.currency(locale: "en_US", symbol: '\$');
  }



  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Transactions", style: TextStyle(fontSize: 16)),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: AppFonts.defaultSize,
                    fontFamily: AppFonts.josefinSansRegular,
                    fontWeight: FontWeight.bold,
                    color: trnxController.stripeTrnx.isEmpty
                        ? ColorPalette.green[200]
                        : ColorPalette.green,
                  ),
                ),
              ],
            ),
            trnxController.stripeTrnx.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: displayHeight(context) / 25),
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: ColorPalette.green[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "\$",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: AppFonts.josefinSansBold,
                              color: ColorPalette.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("You don't have any transactions",
                            style: TextStyle(fontSize: AppFonts.defaultSize)),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // inner list doesn't scroll
                    itemCount: trnxController.stripeTrnx.length,
                    itemBuilder: (context, index) {
                      final e = trnxController.stripeTrnx[index];

                      final withdrawn = (e.type == transfer) ? false : true;
                      final formattedDate = parseBackendUtc(e.created);

                      return TransactionItem(
                        amount: formatCurrency!.format(e.amount),
                        time: formattedDate.toDateTimeString,
                        withdrawn: withdrawn,
                      );
                    },
                  ),
          ],
        ));
  }
}
