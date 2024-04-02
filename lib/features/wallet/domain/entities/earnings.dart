class Earnings {
  int? id;
  int? userId;
  double balance;
  double withdrawn;
  double availableForWithdrawal;
  double pendingClearance;

  Earnings(
      {
        this.id,
        this.userId,
        this.balance = 0.00,
        this.withdrawn = 0.00,
        this.availableForWithdrawal = 0.00,
        this.pendingClearance = 0.00
      });
}