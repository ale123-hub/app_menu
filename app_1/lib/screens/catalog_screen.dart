import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // logout
import '../models/product.dart';
import 'cart_screen.dart';

// Lista de productos
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
  ),
  Product(
    name: 'Seco de Carne',
    description: 'Costilla cocida a presion, acompañado de arroz, ensalada y jugo.',
    price: 2.00,
    image: null,
  ),
  Product(
    name: 'Salchipapa',
    description: 'Papas fritas y salchicha "ensalada al gusto".',
    price: 1.00,
    image: null,
  ),
  Product(
    name: 'Papa Carne',
    description: 'Papa frita con carne molida frita "ensalada al gusto".',
    price: 1.50,
    image: null,
  ),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de los Super Jugos Nachito'),
        actions: [
          // 🛒 Botón del carrito
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          // 🔓 Botón de cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Redirige automáticamente al login gracias al StreamBuilder en main.dart
            },
          ),
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
