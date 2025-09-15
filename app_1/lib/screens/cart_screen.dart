import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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

  // Genera e imprime el PDF con el pedido
  Future<void> _printVoucher(int turno) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Super Jugos Nachito',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Comprobante de Pedido'),
              pw.Text('Turno: #$turno'),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Producto', 'Nota', 'Precio'],
                data: CartScreen.cartItems.map((item) {
                  return [
                    item.name,
                    item.note ?? '-',
                    '\$${item.price.toStringAsFixed(2)}'
                  ];
                }).toList(),
              ),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Muestra un diálogo con el resumen del pedido y opciones
  void _generateVoucher() {
    final voucherNumber = turno++;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Comprobante de Pedido'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Turno: #$voucherNumber'),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: CartScreen.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = CartScreen.cartItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: item.note != null ? Text('Nota: ${item.note}') : null,
                        trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text('Total: \$${total.toStringAsFixed(2)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Atrás'),
            ),
            TextButton(
              onPressed: () async {
                await _printVoucher(voucherNumber);
              },
              child: const Text('Imprimir'),
            ),
            TextButton(
              onPressed: () {
                CartScreen.cartItems.clear();
                Navigator.of(context).pop();
                if (mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }

  // Cancela el pedido actual
  void _cancelOrder() {
    CartScreen.cartItems.clear();
    Navigator.pop(context);
  }

  // Editar nota del producto
  void _editProduct(BuildContext context, int index) {
    final product = CartScreen.cartItems[index];
    final TextEditingController noteController =
        TextEditingController(text: product.note ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar nota al producto'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              labelText: 'Ejem: Con jugo o con Café',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newNote = noteController.text.trim();
                setState(() {
                  CartScreen.cartItems[index] = Product(
                    name: product.name,
                    description: product.description,
                    price: product.price,
                    image: product.image,
                    note: newNote.isNotEmpty ? newNote : null,
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Vista principal del carrito
  @override
  Widget build(BuildContext context) {
    if (CartScreen.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tu Orden es:'),
        ),
        body: const Center(
          child: Text('No hay pedidos realizados'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Orden es:'),
      ),
      body: ListView.builder(
        itemCount: CartScreen.cartItems.length,
        itemBuilder: (context, index) {
          final product = CartScreen.cartItems[index];
          return ListTile(
            title: Text(product.name),
            subtitle: product.note != null
                ? Text('Nota: ${product.note}')
                : null,
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
