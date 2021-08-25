class Product {
  Product({
    this.name = 'null',
    this.picPath = 'null',
    this.weight = 'null',
    this.description =
        '''This is a professional description, so that you can buy our product, go home and be happy!''',
    this.price = 'null',
    this.orderedQuantity = 1,
  });
  final String name;
  final String picPath;
  final String weight;
  final String description;
  final String price;
  int orderedQuantity;
  void makeOrder({int bulkOrder = 0}) {
    if (bulkOrder == 0) {
      orderedQuantity++;
      return;
    }
    orderedQuantity += bulkOrder;
  }
}
