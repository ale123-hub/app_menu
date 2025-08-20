import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_screen.dart';

// Esta lista queda aquí y será usada internamente
final List<Product> products = [
  Product(
    name: 'Tortilla de Verde',
    description: 'Deliciosa tortilla hecha de plátano verde.',
    price: 1.10,
    image: null,
  ),
  Product(
    name: 'Tortilla de Papa',
    description: 'Tortilla tradicional de papa con queso.',
    price: 1.10,
    image: null,
  ),
  Product(
    name: 'Tortilla de Yuca',
    description: 'Tortilla crocante hecha de yuca.',
    price: 1.10,
    image: null,
  ),
  Product(
    name: 'Seco de Pollo',
    description: 'Pollo cocido acompañado de arroz, ensalada y jugo.',
    price: 2.00,
    image: null,
  ),Product(
    name: 'Seco de Carne',
    description: 'Costilla cocida a presion, acompañado de arroz, ensalada y jugo.',
    price: 2.00,
    image: null,
  ),Product(
    name: 'Salchipapa',
    description: 'Papas fritas y salchicha "ensalada al gusto".',
    price: 1.00,
    image: null,
  ),Product(
    name: 'Papa Carne',
    description: 'Papa frita con carne molida frita "ensalada al gusto".',
    price: 1.50,
    image: null,
  ),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key}); // Quitamos el parámetro products

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de los Super Jugos Nachito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.description),
            trailing: Text('\$${product.price.toStringAsFixed(2)}'),
            onTap: () {
              CartScreen.cartItems.add(product);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} añadido al pedido')),
              );
            },
          );
        },
      ),
    );
  }
}
