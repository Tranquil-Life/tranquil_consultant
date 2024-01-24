class Earnings {
  int? id;
  int? userId;
  double balance;
  double withdrawn;
  double availableForWithdrawal;

  Earnings(
      {
        this.id,
        this.userId,
        this.balance = 0.00,
        this.withdrawn = 0.00,
        this.availableForWithdrawal = 0.00
      });
}