class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final String? note;
  int quantity;  // Nueva propiedad de cantidad

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.note,
    this.quantity = 1,  // Valor por defecto de cantidad es 1
  });

  // Método de fábrica para crear un producto desde un mapa
  factory Product.fromMap(Map<String, dynamic> data, {String? id}) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'],
      note: data['note'],
      quantity: data['quantity'] ?? 1, // Asegurarse de que la cantidad sea 1 si no está definida
    );
  }

  // Convertir el producto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'quantity': quantity,  // Incluir la cantidad en el mapa
    };
  }
}
