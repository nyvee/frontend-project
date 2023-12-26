import 'dart:convert';
import 'package:flutter/material.dart';
import '../../components/top_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

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

  ProductDetailsPage({required this.productId});

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
        title: product['name'],
        showSettingsButton: false,
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
              '\Rp${product['price']}',
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
                onPressed: () {
                  // Handle add to cart button pressed
                },
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
                  addToCart(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    final userId = Hive.box('myBox').get('userId');

    try {
      // Add a copy of the product to the cart, with an amount of 1.
      Map<String, dynamic> productCopy = Map<String, dynamic>.from(product);
      productCopy['quantity'] = 1;

      // Fetch the current user data.
      final userUrl =
          Uri.parse('https://gjq3q54r-8080.asse.devtunnels.ms/user/$userId');
      final userResponse = await http.get(userUrl, headers: {
        'Content-Type': 'application/json',
      });

      if (userResponse.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(userResponse.body);

        // Add the new product to the user's cart.
        List<dynamic> cart = List<dynamic>.from(userData['data']['cart']);
        cart.add(productCopy);
        userData['data']['cart'] = cart;

        // Update the user data on the server.
        final updateResponse = await http.post(
          userUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(userData),
        );

        if (updateResponse.statusCode == 200) {
          print('Product added to cart.');
        } else {
          print(
              'Failed to add product to cart. Server responded with status code: ${updateResponse.statusCode}');
          print('Response body: ${updateResponse.body}');
        }
      } else {
        print(
            'Failed to fetch user data. Server responded with status code: ${userResponse.statusCode}');
        print('Response body: ${userResponse.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
