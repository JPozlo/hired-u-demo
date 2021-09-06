class Product {
  Product({
    this.name = 'null',
    this.picPath,
    // this.weight = 'null',
    this.foodCategory = "null",
    this.description =
        '''This is a professional description, so that you can buy our product, go home and be happy!''',
    this.price = 0.0,
    this.orderedQuantity = 1,
  });
  final String name;
  final List<String> picPath;
  // final String weight;
  final String description;
  final String foodCategory;
  final double price;
  int orderedQuantity;
  void makeOrder({int bulkOrder = 0}) {
    if (bulkOrder == 0) {
      orderedQuantity++;
      return;
    }
    orderedQuantity += bulkOrder;
  }

  @override
  String toString() {
    return "The product name: $name\n The product price is: $price";
  }
}
