class PaymentHistory {
  PaymentHistory(
      {this.amount,
      this.status});

  final String status;
  final int amount;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
      amount: json['amount'] as int,
      status: json['status'] as String);
}
