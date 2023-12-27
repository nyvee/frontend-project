// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_project/components/carousel.dart';
import 'package:frontend_project/components/item_card.dart';
import 'package:http/http.dart' as http;
import 'subpages/search_bar.dart';

class Product {
  final String name;
  final String overview;
  final String image;
  final int price;
  final String productId;

  Product({
    required this.name,
    required this.overview,
    required this.image,
    required this.price,
    required this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      overview: json['overview'],
      image: json['image'],
      price: json['price'],
      productId: json['_id'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final PageController _recommendedPageController1 = PageController();
  final PageController _recommendedPageController2 = PageController();
  late List<Product> _recommendedProductsContainer1 = [];
  late List<Product> _recommendedProductsContainer2 = [];
  bool _recommendedProductsLoaded = false;

  Future<List<Product>> fetchProducts() async {
    const url = 'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Product> products =
          data.map((item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecommendedProducts();
  }

  Future<void> _loadRecommendedProducts() async {
    if (!_recommendedProductsLoaded) {
      try {
        final products = await fetchProducts();
        List<Product> shuffledProducts = List.from(products)..shuffle();
        setState(() {
          _recommendedProductsContainer1 = shuffledProducts;
          _recommendedProductsContainer2 = List.from(shuffledProducts)
            ..shuffle();
          _recommendedProductsLoaded = true;
        });
      } catch (e) {
        print('Error loading recommended products: $e');
      }
    }
  }

  Widget _buildIconContainer(IconData iconData) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xFF31314D),
          width: 2.2,
        ),
        color: Colors.transparent,
      ),
      child: Center(
        child: FaIcon(iconData, color: const Color(0xFF31314D), size: 20.0),
      ),
    );
  }

  @override
  void dispose() {
    // _stopTimer();
    _pageController.dispose();
    _recommendedPageController1.dispose();
    _recommendedPageController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EBE5),
        elevation: 6,
        toolbarHeight: 125.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 220,
                      height: 40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xFF31304D),
                            width: 2.2,
                          ),
                          color: const Color(0xFFF0EBE5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Color(0xFF31304D)),
                            const SizedBox(
                              width: 5,
                              height: 0,
                            ),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 18.0, height: 1.2),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12.0),
                                  isDense: true,
                                ),
                                onSubmitted: (productName) {
                                  if (productName.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Searchh(searchInput: productName),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 0.0),
                      child: Row(
                        children: [
                          _buildIconContainer(FontAwesomeIcons.solidHeart),
                          const SizedBox(width: 18.0),
                          _buildIconContainer(FontAwesomeIcons.solidBell),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 40.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildMenuBox('All'),
                  buildMenuBox('Men'),
                  buildMenuBox('Women'),
                  buildMenuBox('Kids'),
                  buildMenuBox('Accessories'),
                  buildMenuBox('Seasonal Picks'),
                  buildMenuBox('Sale'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF0ECE5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15.0),

              // Carousel
              const Carousel(),
              // Container pertama
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 10.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended for you',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF31304D)),
                    ),
                    const SizedBox(height: 8.0),
                    // Slide produk
                    if (_recommendedProductsLoaded)
                      SizedBox(
                        height: 280.0,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.6),
                          itemCount: _recommendedProductsContainer1.length,
                          itemBuilder: (context, index) {
                            return ItemCard(
                              productName:
                                  _recommendedProductsContainer1[index].name,
                              description: _recommendedProductsContainer1[index]
                                  .overview,
                              imagePath:
                                  _recommendedProductsContainer1[index].image,
                              price:
                                  _recommendedProductsContainer1[index].price,
                              color1: const Color(0xFFF0ECE5),
                              color2: const Color(0xFF31304D),
                              productId: _recommendedProductsContainer1[index]
                                  .productId,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // Container kedua
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 10.0),
                color: const Color(0xFF31304D),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended for you',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF0ECE5)),
                    ),
                    const SizedBox(height: 8.0),
                    // Slide produk
                    if (_recommendedProductsLoaded)
                      SizedBox(
                        height: 280.0,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.6),
                          itemCount: _recommendedProductsContainer2.length,
                          itemBuilder: (context, index) {
                            return ItemCard(
                              productName:
                                  _recommendedProductsContainer2[index].name,
                              description: _recommendedProductsContainer2[index]
                                  .overview,
                              imagePath:
                                  _recommendedProductsContainer2[index].image,
                              price:
                                  _recommendedProductsContainer2[index].price,
                              color1: const Color(0xFF31304D),
                              color2: const Color(0xFFF0ECE5),
                              productId: _recommendedProductsContainer2[index]
                                  .productId,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildMenuBox(String text) {
  return Container(
    margin: const EdgeInsets.only(left: 11.0),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: const Color(0xFF31304D), width: 2.2),
      color: Colors.transparent,
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF31304D)),
      ),
    ),
  );
}
