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
  try {
    final response = await http.get(
      Uri.parse(
          'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/$productId'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> product = jsonDecode(response.body);
      return product['data'];
    } else {
      throw Exception('Failde to Load Product');
    }
  } catch (e) {
    logger.e('Error fetching product: $e');
    return Future.error('Failde to Get Product');
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  ProductDetailsPage({required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isOnWishlist = false;
  late Future<Map<String, dynamic>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProduct(widget.productId);
    _checkWishlistStatus();
    // someFunction();
  }

  // void someFunction() async {
  //   bool isSuccess = await _checkWishlistStatus();

  //   if (isSuccess) {
  //     // Wishlist berhasil dicek
  //     print('Wishlist checked successfully');
  //   } else {
  //     // Gagal melakukan cek wishlist
  //     print('Failed to check wishlist');
  //   }
  // }

  Future<void> _checkWishlistStatus() async {
    try {
      final userId = Hive.box('myBox').get('userId');
      final url = Uri.parse(
          'https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(response.body);
        List<dynamic> wishlistItemsJson = userData['data']['wishlist'];
        setState(() {
          isOnWishlist = wishlistItemsJson
              .any((item) => item['productid'] == widget.productId);
        });
        // return true;
      } else {
        logger.e('Check wishlist status - Status code: ${response.statusCode}');
        logger.e('Check wishlist status - Response body: ${response.body}');
        throw Exception('Failed to load wishlist');
      }
    } catch (e) {
      logger.e('Error checking wishlist status: $e');
      return Future.error('Error checking wishlist status');
    }
  }

  Future<void> _toggleWishlistStatus(String productId) async {
    try {
      if (isOnWishlist) {
        await removeFromWishlist(productId);
      } else {
        await addToWishlist(productId);
      }
      await _checkWishlistStatus();
    } catch (e) {
      logger.e('Error toggling wishlist status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
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
      backgroundColor: Color.fromARGB(255, 240, 236, 229),
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
                textStyle: TextStyle(
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
                  textStyle: TextStyle(
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
                textStyle: TextStyle(
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
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 49, 48, 77)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(
            color: Color.fromARGB(255, 49, 48, 77),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Details',
              style: const TextStyle(
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
                textStyle: TextStyle(
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
                textStyle: TextStyle(
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
              padding: EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  _toggleWishlistStatus(product['_id']);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isOnWishlist
                        ? Color.fromARGB(255, 49, 48, 77)
                        : Color.fromARGB(255, 240, 236, 229),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 49, 48, 77),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isOnWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isOnWishlist
                        ? Color.fromARGB(255, 240, 236, 229)
                        : Color.fromARGB(255, 49, 48, 77),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 49, 48, 77), // background color
                  foregroundColor:
                      Color.fromARGB(255, 240, 236, 229), // text color
                  padding: const EdgeInsets.fromLTRB(
                      40, 10, 40, 10), // inner padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
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
              padding: EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 240, 236, 229), // background color
                  foregroundColor:
                      Color.fromARGB(255, 49, 48, 77), // text color
                  padding: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // inner padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
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

Future<void> addToWishlist(String productId) async {
  try {
    final url = Uri.parse(
        'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/wishlist/$productId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'productId': productId,
      }),
    );
    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  } catch (e) {
    logger.e('Error adding to wishlist: $e');
    return Future.error('Error adding to wishlist');
  }
}

Future<void> removeFromWishlist(String productId) async {
  try {
    final url = Uri.parse(
        'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/wishlist/$productId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'productId': productId,
      }),
    );
    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from wishlist');
    }
  } catch (e) {
    logger.e('Error removing from wishlist: $e');
    return Future.error('Error removing from wishlist');
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
