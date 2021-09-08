
enum OrderStatus { IN_PROGRESS, COMPLETED, CANCELLED }
enum OrderPayStatus{ PAID, PAY }

class Order {
  final int id;
  final String name;
  final String services;
  final String phone;
  final String location;
  final String paymentId;
  final String manualApproval;
  final String specifics;
  final String price;
  final String cancelId;
  final String cleanerId;
  final OrderStatus status;
  final String createdAt;
  final String updatedAt;
  final String deliveryDate;
  final String deliveryTime;
  final String userId;

  Order({
    this.id,
    this.userId,
    this.paymentId,
    this.phone,
    this.price,
    this.status,
    this.services,
    this.specifics,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.manualApproval,
    this.location,
    this.cancelId,
    this.cleanerId,
    this.deliveryDate,
    this.deliveryTime
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderId'] as int,
      name: json['name'] ?? null,
      phone: json['phone'],
      price: json['price'],
      manualApproval: json['manual_approval'],
      location: json['location'],
      specifics: json['specifics'],
      status: json['status'],
      userId: json['userId'].toString(),
      paymentId: json['payment_id'] as String,
      cleanerId: json['cleaner_id'] as String,
      cancelId: json['cancel_id'] as String,
      services: json['services'],
      deliveryTime: json['time'] as String,
      deliveryDate: json['date'] as String,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'services': services,
    'orderStatus': status,
  };


  @override
  String toString() {
    return "The id:$id\n status: $status\n services:$services";
  }

}
