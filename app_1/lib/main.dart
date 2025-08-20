import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App menú',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CatalogScreen(), // Esta es tu pantalla principal
      debugShowCheckedModeBanner: false,
    );
  }
}
