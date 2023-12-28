// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, prefer_typing_uninitialized_variables, annotate_overrides, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'subpages/search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'subpages/product_details_page.dart';
import 'subpages/wishlist_page.dart';

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

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<Product>> products;
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final url = 'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products';
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

  Widget _buildIconContainer(IconData iconData, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
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
                          _buildIconContainer(FontAwesomeIcons.solidHeart, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WishlistPage()),
                            );
                          }),
                          const SizedBox(width: 18.0),
                          _buildIconContainer(
                              FontAwesomeIcons.solidBell, () {}),
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
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return _buildProductCard(product);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsPage(productId: product.productId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: const Color(0xFF31314D),
            width: MediaQuery.of(context).size.width * 0.47,
            height: MediaQuery.of(context).size.width * 0.69,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              product.name,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        product.overview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        ).format(product.price),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          FaIcon(
                            FontAwesomeIcons.cartShopping,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
