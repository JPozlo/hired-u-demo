class OrderItem {
  OrderItem({required this.id, required this.quantity});
  final int id;
  final int quantity;

  Map<String, dynamic> toJson() => {'id': id, 'quantity': quantity};

  @override
  String toString() {
    return "The id: $id and quantity: $quantity";
  }
}
