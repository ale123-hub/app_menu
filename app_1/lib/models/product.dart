class Product {
  final String name;
  final String description;
  final double price;
  final String? image;
  final String? note; // Nueva propiedad opcional

  Product({
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.note, // Inclúyela también en el constructor
  });
}
