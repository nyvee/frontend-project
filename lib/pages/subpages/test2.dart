import 'package:flutter/material.dart';
import 'package:frontend_project/components/top_app_bar.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '/components/checkout_item_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

final logger = Logger();

String userId = Hive.box('myBox').get('token');

Future<List<CartItem>> fetchCart(String userId) async {
  final url =
      Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/checkout');
  final response = await http.get(
    url,
    headers: {'Content-Type': 'application/json'},
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

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isPaymentOptionsVisible = false;
  String selectedPaymentOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: MyAppBar(
        title: 'Checkout',
        showSettingsButton: false,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<CartItem>>(
          future: fetchCart(userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<CartItem> cartItems = snapshot.data;
              logger.i(cartItems);
              double total = calculateTotalPrice(cartItems);
              return Column(
                children: [
                  _buildCheckoutList(cartItems),
                  deliverCard(),
                  _buildCheckoutButton(total),
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

  double calculateTotalPrice(List<CartItem> cartItems) {
    return cartItems
        .map((item) => item.price * item.amount)
        .fold(0, (prev, price) => prev + price);
  }

  Widget _buildCheckoutList(List<CartItem> cartItems) {
    return Container(
      height: 105 * cartItems.length.toDouble(),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          // return buildCheckoutItemCard(cartItems[index])
        },
      ),
    );
  }

  Widget deliverCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 236, 231, 212),
          borderRadius: BorderRadius.circular(3.0),
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery and Payment",
              style: GoogleFonts.montserrat(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: 5.0),
            Container(width: 143.0, height: 1.5, color: Colors.black),
            SizedBox(height: 10.0),
            deliveryForm(),
          ],
        ),
      ),
    );
  }

  Widget deliveryForm() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 217, 217, 217),
        borderRadius: BorderRadius.circular(3.0),
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.fromLTRB(17.0, 13.0, 17.0, 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery",
            style: GoogleFonts.montserrat(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: 10.0),
          deliveryFormField("Name"),
          deliveryFormField("Phone"),
          deliveryFormField("Street"),
          deliveryFormField("City"),
          deliveryFormField("State"),
          deliveryFormField("Zipcode"),
          deliveryFormField("Country"),
        ],
      ),
    );
  }

  Widget deliveryFormField(String label) {
    return Row(
      children: [
        Text(
          "$label :",
          style: GoogleFonts.montserrat(
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            style: GoogleFonts.montserrat(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(double total) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 236, 229),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4.0,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.04,
        screenHeight * 0.01,
        screenWidth * 0.04,
        screenHeight * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Total Price :',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(100, 49, 48, 77),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(total),
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 49, 48, 77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.15,
                screenHeight * 0.015,
                screenWidth * 0.15,
                screenHeight * 0.015,
              ),
            ),
            child: const Text(
              'Buy',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
