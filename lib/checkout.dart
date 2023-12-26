import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Man's Suit"),
            subtitle: Text("m | Dark Blue"),
            trailing: Text("Rp1.990.000"),
          ),
          ListTile(
            title: Text("Man's Suit"),
            subtitle: Text("m | Dark Blue"),
            trailing: Text("Rp1.990.000"),
          ),
          Divider(),
          ListTile(
            title: Text("Delivery and Payment"),
          ),
          ListTile(
            title: Text("Delivery"),
            subtitle: Text("01233432521234"),
            trailing: Text("xxxxxxx (your address)"),
          ),
          ListTile(
            title: Text("Payment"),
            trailing: Text("Bank X"),
          ),
          ListTile(
            title: Text("Total price"),
            trailing: Text("Rp3.980.000"),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Buy"),
            onTap: () {
              // Do something when the buy button is tapped.
            },
          ),
        ],
      ),
    );
  }
}
