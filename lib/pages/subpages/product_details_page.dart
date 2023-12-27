// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import '../../components/top_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final logger = Logger();
String token = Hive.box('myBox').get('token');

Future<Map<String, dynamic>> fetchProduct(String productId) async {
  final response = await http.get(
    Uri.parse(
        'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/$productId'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> product = jsonDecode(response.body);
    return product['data'];
  } else {
    throw Exception('Failed to load product');
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Map<String, dynamic>> _productFuture;
  bool isOnWishlist = false;

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return buildProductDetailsPage(snapshot.data!);
        }
      },
    );
  }

  Widget buildProductDetailsPage(Map<String, dynamic> product) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: MyAppBar(
        showBackButton: true,
        title: product['name'],
      ),
      body: ListView(
        children: [
          Image.network(
            product['image'],
            height: MediaQuery.of(context).size.height / 2.4,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              product['name'],
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 48, 77)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(product['overview'],
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 49, 48, 77),
                  ),
                )),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Quantity: ${product['quantity']}',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 48, 77)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(product['price']),
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 48, 77)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Color.fromARGB(255, 49, 48, 77),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Details',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 49, 48, 77)),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              product['description'],
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 49, 48, 77)),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Rating: ${product['rating']}',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 48, 77)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Reviews: ${product['numReviews']}',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 49, 48, 77)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 240, 236, 229),
        elevation: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  // Handle favorite/wishlist button pressed
                  setState(() {
                    isOnWishlist = !isOnWishlist;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isOnWishlist
                        ? const Color.fromARGB(255, 49, 48, 77)
                        : const Color.fromARGB(255, 240, 236, 229),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 49, 48, 77),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isOnWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isOnWishlist
                        ? const Color.fromARGB(255, 240, 236, 229)
                        : const Color.fromARGB(255, 49, 48, 77),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 49, 48, 77), // background color
                  foregroundColor:
                      const Color.fromARGB(255, 240, 236, 229), // text color
                  padding: const EdgeInsets.fromLTRB(
                      40, 10, 40, 10), // inner padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 49, 48, 77),
                        width: 2), // border color and width
                  ),
                  elevation: 0, // remove shadow
                ),
                child: const Text('Buy Now'),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 240, 236, 229), // background color
                  foregroundColor:
                      const Color.fromARGB(255, 49, 48, 77), // text color
                  padding: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // inner padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 49, 48, 77),
                        width: 2), // border color and width
                  ),
                  elevation: 0, // remove shadow
                ),
                child: const Text('Add to Cart'),
                onPressed: () {
                  addToCart(product['_id'], 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> addToCart(String productId, int quantity) async {
  final url = Uri.parse(
      'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/$productId/cart');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'productId': productId,
      'quantity': quantity,
    }),
  );
  logger.i('Response status: ${response.statusCode}');
  logger.i('Response body: ${response.body}');

  if (response.statusCode == 200) {
    Map<String, dynamic> product = jsonDecode(response.body);
    logger.i('Product: $product');
  } else {
    throw Exception('Failed to load product');
  }
}
