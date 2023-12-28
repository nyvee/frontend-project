import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:frontend_project/components/top_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '/components/cart_item_card.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './subpages/checkout_page.dart';

final logger = Logger();

String userId = Hive.box('myBox').get('userId');

Future<List<CartItem>> fetchCart(String userId) async {
  final url =
      Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/$userId');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> userData = jsonDecode(response.body);
    logger.i(userData['data']['cart']);
    List<dynamic> cartItemsJson = userData['data']['cart'];
    return cartItemsJson.map((item) => CartItem.fromJson(item)).toList();
  } else {
    logger.e('Status code: ${response.statusCode}');
    logger.e('Response body: ${response.body}');
    throw Exception('Failed to load cart');
  }
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  set items(List<CartItem> value) {
    _items = value;
    notifyListeners();
  }

  Future<void> fetchCartItems(String userId) async {
    items = await fetchCart(userId);
  }
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> futureCartItems;

  @override
  void initState() {
    super.initState();
    futureCartItems = fetchCart(userId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: const MyAppBar(title: 'Shopping Cart'),
      body: FutureBuilder<List<CartItem>>(
        future: futureCartItems,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<CartItem> cartItems = snapshot.data;
            logger.i(cartItems);
            double total = calculateTotalPrice(cartItems);
            return Column(
              children: [
                Expanded(
                  child: _buildCartList(
                      cartItems, screenWidth, screenHeight * 0.8),
                ),
                _buildCheckoutButton(
                    context, total, screenWidth, screenHeight * 0.2),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  double calculateTotalPrice(List<CartItem> cartItems) {
    double total = 0.0;
    for (CartItem item in cartItems) {
      total += item.price * item.amount;
    }
    return total;
  }

  Widget _buildCartList(
      List<CartItem> cartItems, double screenWidth, double screenHeight) {
    return RefreshIndicator(
      color: const Color.fromARGB(255, 49, 48, 77),
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      onRefresh: () async {
        setState(() {
          futureCartItems = fetchCart(userId);
        });
      },
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          CartItem item = cartItems[index];
          return buildCartItemCard(item, screenWidth, screenHeight);
        },
      ),
    );
  }

  Widget _buildCheckoutButton(
      BuildContext context, total, screenWidth, screenHeight) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 240, 236, 229),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 4.0,
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.01,
              screenWidth * 0.04, screenHeight * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Total Price :',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(100, 49, 48, 77),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: NumberFormat.currency(
                        locale:
                            'id_ID', // Use 'en_US' for English format, 'id_ID' for Indonesian format, adjust as needed
                        symbol: 'Rp',
                        decimalDigits: 0,
                      ).format(total), // Use the total parameter
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 49, 48, 77),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 49, 48, 77), // Use 'const' for performance
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.15,
                      screenHeight * 0.015,
                      screenWidth * 0.15,
                      screenHeight * 0.015), // Move padding here
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
