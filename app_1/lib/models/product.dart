class Product {
  final String name;
  final String description;
  final double price;
  final String? image;

  Product({
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });
}
