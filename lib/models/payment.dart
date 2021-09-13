class Payment {
  Payment(
      {this.amount,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.serviceOrdersId});

  final String updatedAt;
  final String createdAt;
  final int amount;
  final int id;
  final int serviceOrdersId;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as int,
    amount: json['amount'] as int,
    serviceOrdersId: json['service_orders_id'] as int,
    updatedAt: json['updated_at'] as String,
    createdAt: json['created_at'] as String
  );
}
