import 'package:flutter/material.dart';
import 'package:frontend_project/components/appbar.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CartItem> cartItems = [
      CartItem(
          imageUrl: 'my-image-url',
          name: 'Product 1',
          price: 50000.0,
          amount: 2),
      CartItem(
          imageUrl: 'my-image-url',
          name: 'Product 2',
          price: 700000.0,
          amount: 1),
      CartItem(
          imageUrl: 'imageUrl',
          name: 'Ardika Head',
          price: 1999999.0,
          amount: 2)
    ];

    double total = calculateTotalPrice(cartItems);

    return Scaffold(
      appBar: MyAppBar(title: 'Shopping Cart', showSettingsButton: false),
      body: _buildCartList(cartItems),
      backgroundColor: const Color.fromARGB(255, 240, 236, 229),
      bottomNavigationBar: _buildCheckoutButton(total),
    );
  }

  double calculateTotalPrice(List<CartItem> cartItems) {
    double total = 0.0;
    for (CartItem item in cartItems) {
      total += item.price * item.amount;
    }
    return total;
  }

  Widget _buildCartList(List<CartItem> cartItems) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        CartItem item = cartItems[index];
        return Card(
          margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
              ),
              Positioned(
                top: 8.0,
                left: 88.0,
                child: Text(item.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Positioned(
                bottom: 8.0,
                left: 88.0,
                child: Text(
                  NumberFormat.currency(
                    locale:
                        'id_ID', // Use 'en_US' for English format, 'id_ID' for Indonesian format, adjust as needed
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(item.price * item.amount),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Ink(
                    height: 30.0,
                    width: 30.0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      onTap: () {},
                      child: Icon(
                        Icons.delete,
                        size: 20.0,
                        color: Color.fromARGB(255, 49, 48, 77),
                      ),
                    ),
                  )),
              Positioned(
                bottom: 8.0,
                right: 8.0,
                child: Row(
                  children: [
                    Ink(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 236, 229),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                        onTap: () {},
                        child: Icon(
                          Icons.remove,
                          size: 15.0,
                          color: Color.fromARGB(255, 49, 48, 77),
                        ),
                      ),
                    ),
                    SizedBox(width: 1.0),
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 236, 229),
                      ),
                      child: Center(
                        child: Text('${item.amount}'),
                      ),
                    ),
                    SizedBox(width: 1.0),
                    Ink(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 236, 229),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        onTap: () {},
                        child: Icon(
                          Icons.add,
                          size: 15.0,
                          color: Color.fromARGB(255, 49, 48, 77),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckoutButton(total) {
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
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 49, 48, 77), // Use 'const' for performance
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding:
                      EdgeInsets.fromLTRB(80, 20, 80, 20), // Move padding here
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

class CartItem {
  final String name;
  final double price;
  final int amount;
  final String imageUrl;

  CartItem(
      {required this.imageUrl,
      required this.name,
      required this.price,
      required this.amount});
}
