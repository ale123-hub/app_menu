import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _db.collection('products').get();

      // Debug
      log('Documents fetched: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        log('Doc id: ${doc.id}, data: ${doc.data()}');
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          image: data['image'] ?? '',
          note: data['note'] ?? data['nota'] ?? '',
        );
      }).toList();
    } catch (e, s) {
      log('Error fetching products', error: e, stackTrace: s);
      return [];
    }
  }
}
