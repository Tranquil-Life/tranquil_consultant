class Earnings {
  int? id;
  int? userId;
  double netInCome;
  double withdrawn;
  double availableForWithdrawal;
  double pendingClearance;
  double expectedEarnings;

  Earnings(
      {
        this.id,
        this.userId,
        this.netInCome = 0.00,
        this.withdrawn = 0.00,
        this.availableForWithdrawal = 0.00,
        this.pendingClearance = 0.00,
        this.expectedEarnings = 0.00
      });
}