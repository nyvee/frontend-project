// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Product {
  final int id;
  final String nama;
  final double harga;
  
  var keterangan;

  Product({required this.id, required this.keterangan, required this.nama, required this.harga});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      keterangan : json['keterangan'],
      nama: json['name'],
      harga: json['price'].toDouble(),
    );
  }
}


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: products == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].nama),
                  subtitle: Text('\$${products[index].harga.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
  
  void fetchProducts() {}
}

void main() {
  runApp(const MaterialApp(
    home: ProductListScreen(),
  ));
}
