// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:frontend_project/components/top_app_bar.dart';

class Product {
  final int id;
  final String nama;
  final double harga;

  var keterangan;

  Product(
      {required this.id,
      required this.keterangan,
      required this.nama,
      required this.harga});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      keterangan: json['keterangan'],
      nama: json['name'],
      harga: json['price'].toDouble(),
    );
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    products = [];
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Explore',
        showSettingsButton: false,
        showBackButton: false,
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
                  subtitle:
                      Text('\$${products[index].harga.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }

  void fetchProducts() {}
}
