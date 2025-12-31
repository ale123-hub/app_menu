import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de los Super Jugos Nachito'),
        actions: [
          // Carrito
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
          // Cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();

                // Check if the widget is still mounted before showing the SnackBar
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sesión cerrada con éxito'),
                    ),
                  );
                }
              } catch (e) {
                // Check if the widget is still mounted before showing the SnackBar
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al cerrar sesión'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productService.getProducts(),
        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocurrió un error al cargar los productos'),
            );
          }

          // Sin datos
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles'),
            );
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                ),
                onTap: () {
                  // Agregar el producto al carrito
                  CartScreen.cartItems.add(product);

                  // Mostrar un mensaje al usuario
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} añadido al pedido'),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
