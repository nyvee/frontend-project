import 'package:flutter/material.dart';
import 'package:frontend_project/components/top_app_bar.dart';
import 'package:frontend_project/components/wishlist_item_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

final logger = Logger();

String userId = Hive.box('myBox').get('userId');

Future<List<WishlistItem>> fetchCart(String userId) async {
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
    logger.i(userData['data']['wishlist']);
    List<dynamic> wishlistItemsJson = userData['data']['wishlist'];
    return wishlistItemsJson
        .map((item) => WishlistItem.fromJson(item))
        .toList();
  } else {
    logger.e('Status code: ${response.statusCode}');
    logger.e('Response body: ${response.body}');
    throw Exception('Failed to load cart');
  }
}

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: MyAppBar(
          title: 'Whislist', showSettingsButton: false, showBackButton: true),
      body: SingleChildScrollView(
        child: FutureBuilder<List<WishlistItem>>(
          future: fetchCart(userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<WishlistItem> cartItems = snapshot.data;
              logger.i(cartItems);
              return Column(
                children: [
                  Container(
                    height: (105 - 0.8) * cartItems.length.toDouble(),
                    child: _buildWishlist(
                      cartItems,
                      screenWidth,
                      screenHeight * 0.8,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildWishlist(
      List<WishlistItem> cartItems, double screenWidth, double screenHeight) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        WishlistItem item = cartItems[index];
        return buildWishlistItemCard(item, screenWidth, screenHeight, context);
      },
    );
  }
}
