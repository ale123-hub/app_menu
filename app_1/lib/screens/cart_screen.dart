import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  static List<Product> cartItems = [];

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static int turno = 1;

  double get total =>
      CartScreen.cartItems.fold(0, (sum, item) => sum + item.price);

  void _generateVoucher() {
    final voucherNumber = turno++;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Comprobante de Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Turno: #$voucherNumber'),
              ...CartScreen.cartItems.map((item) => ListTile(
                    title: Text(item.name),
                    trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                  )),
              const Divider(),
              Text('Total: \$${total.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra solo el diálogo
              },
              child: const Text('Atrás'),
            ),
            TextButton(
              onPressed: () {
                CartScreen.cartItems.clear();

                Navigator.of(context).pop(); // Cierra el diálogo

                // Luego intenta cerrar la pantalla del carrito si es posible
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Finalizar pedido'),
            ),
          ],
        );
      },
    );
  }

  void _cancelOrder() {
    CartScreen.cartItems.clear();
    Navigator.pop(context);
  }

  void _editProduct(BuildContext context, int index) {
    final product = CartScreen.cartItems[index];
    final TextEditingController nameController =
        TextEditingController(text: product.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nombre del producto'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nuevo nombre'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    CartScreen.cartItems[index] = Product(
                      name: newName,
                      description: product.description,
                      price: product.price,
                      image: product.image,
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (CartScreen.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tu orden es:'),
        ),
        body: const Center(
          child: Text('No hay pedidos realizados'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Pedido'),
      ),
      body: ListView.builder(
        itemCount: CartScreen.cartItems.length,
        itemBuilder: (context, index) {
          final product = CartScreen.cartItems[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _editProduct(context, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      CartScreen.cartItems.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Total'),
                trailing: Text('\$${total.toStringAsFixed(2)}'),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelOrder,
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _generateVoucher,
                      child: const Text('Confirmar pedido'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
