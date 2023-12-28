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

String userId = Hive.box('myBox').get('userId');
String token = Hive.box('myBox').get('token');

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

Future<bool> checkout({
  required String name,
  required String phone,
  required String street,
  required String city,
  required String state,
  required String zipCode,
  required String country,
  required String paymentMethode,
}) async {
  final url =
      Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/checkout');

  final Map<String, dynamic> requestBody = {
    'name': name,
    'phone': phone,
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
    'paymentMethode': paymentMethode,
  };

  try {
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      print('Checkout succesful!');
    } else {
      print('Failed to checkout. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error during checkout request: $e');
  }
  return true;
}

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isPaymentOptionsVisible = false;
  String selectedPaymentOption = '';
  String actualPayment = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController paymentMethodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      appBar: MyAppBar(
          title: 'Checkout', showSettingsButton: false, showBackButton: true),
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
                  Container(
                    height: (105 - 0.8) * cartItems.length.toDouble(),
                    child: _buildCheckoutList(
                      cartItems,
                      screenWidth,
                      screenHeight * 0.8,
                    ),
                  ),
                  deliverCard(),
                  _buildCheckoutButton(
                    context,
                    total,
                    screenWidth,
                    screenHeight * 0.2,
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

  double calculateTotalPrice(List<CartItem> cartItems) {
    double total = 0.0;
    for (CartItem item in cartItems) {
      total += item.price * item.amount;
    }
    return total;
  }

  Widget _buildCheckoutList(
      List<CartItem> cartItems, double screenWidth, double screenHeight) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        CartItem item = cartItems[index];
        return buildCheckoutItemCard(
          item,
          screenWidth,
          screenHeight,
        );
      },
    );
  }

  Widget deliverCard() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 236, 231, 212),
            borderRadius:
                BorderRadius.circular(3.0), // Atur radius sudut menjadi tumpul
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
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: 143.0,
                height: 1.5,
                color: Colors.black,
              ),
              SizedBox(height: 10.0),
              Container(
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
                        ),
                      ),
                      SizedBox(height: 10.0),
                      deliveryFormField("Name", nameController),
                      deliveryFormField("Phone", phoneController),
                      deliveryFormField("Street", streetController),
                      deliveryFormField("City", cityController),
                      deliveryFormField("State", stateController),
                      deliveryFormField("Zipcode", zipCodeController),
                      deliveryFormField("Country", countryController),
                    ],
                  )),
              SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 217, 217, 217),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.fromLTRB(17.0, 13.0, 17.0, 13.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment",
                          style: GoogleFonts.montserrat(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isPaymentOptionsVisible =
                                  !isPaymentOptionsVisible;
                            });
                          },
                          child: Icon(
                              isPaymentOptionsVisible
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isPaymentOptionsVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPaymentOptionButton(
                              'Bank X', paymentMethodeController),
                          _buildPaymentOptionButton(
                              'Credit Card', paymentMethodeController),
                          _buildPaymentOptionButton(
                              'Dana', paymentMethodeController),
                          _buildPaymentOptionButton(
                              'PayPal', paymentMethodeController),
                          _buildPaymentOptionButton(
                              'Indomaret', paymentMethodeController),
                          _buildPaymentOptionButton(
                              'Alfamart', paymentMethodeController),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: selectedPaymentOption.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 8.0),
                          Text(
                            'Selected Payment Option: $selectedPaymentOption',
                            style: GoogleFonts.montserrat(
                              fontSize: 11.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildPaymentOptionButton(
      String option, TextEditingController controller) {
    if (option == 'Dana') {
      actualPayment = 'dana';
    } else if (option == 'PayPal') {
      actualPayment = 'paypal';
    } else if (option == 'Credit Card') {
      actualPayment = 'crediit_card';
    } else if (option == 'Bank X') {
      actualPayment = 'bank_transfer';
    } else if (option == 'Indomaret') {
      actualPayment = 'indomaret';
    } else if (option == 'Alfamart') {
      actualPayment = 'alfamaret';
    }

    return TextButton(
      onPressed: () {
        _selectPaymentOption(option);
      },
      child: Text(
        option,
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 11.0,
          fontWeight: selectedPaymentOption == option
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    );
  }

  void _selectPaymentOption(String option) {
    setState(() {
      selectedPaymentOption = option;
      isPaymentOptionsVisible = false;
    });
  }

  Widget deliveryFormField(String label, TextEditingController controller) {
    return Row(
      children: [
        Text(
          "$label :",
          style: GoogleFonts.montserrat(
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: controller,
            style: GoogleFonts.montserrat(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
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

  Widget _buildCheckoutButton(
      BuildContext context, total, screenWidth, screenHeight) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 236, 229),
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
                  checkout(
                    name: nameController.text,
                    phone: phoneController.text,
                    street: streetController.text,
                    city: cityController.text,
                    state: stateController.text,
                    zipCode: zipCodeController.text,
                    country: countryController.text,
                    paymentMethode: actualPayment,
                  ).then((Success) {
                    if (Success) {
                      Navigator.pop(context);
                    } else {
                      // Tampilkan pesan kesalahan jika diperlukan
                      print('Checkout failed');
                    }
                  });
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
        ),
      ],
    );
  }
}
