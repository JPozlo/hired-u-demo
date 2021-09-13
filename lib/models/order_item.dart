class OrderItem {
  OrderItem({this.id, this.quantity});
  final int id;
  final int quantity;

  Map<String, dynamic> toJson() => {'id': id, 'quantity': quantity};
}
