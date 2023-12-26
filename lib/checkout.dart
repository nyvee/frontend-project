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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total price",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  "Rp3.980.000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.white),
                    title: Text(
                      "Buy",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Do something when the buy button is tapped.
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
