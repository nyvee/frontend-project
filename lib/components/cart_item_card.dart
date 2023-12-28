import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItem {
  final String productid;
  final String name;
  final String overview;
  final String imageUrl;
  final int amount;
  final int price;
  final String id;

  CartItem({
    required this.productid,
    required this.name,
    required this.overview,
    required this.imageUrl,
    required this.amount,
    required this.price,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productid: json['productid'],
      name: json['name'],
      overview: json['overview'],
      imageUrl: json['image'],
      amount: json['quantity'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

Widget buildCartItemCard(
    CartItem item, double screenWidth, double screenHeight) {
  return Card(
    margin: EdgeInsets.fromLTRB(
        screenWidth * 0.075, screenHeight * 0.025, screenWidth * 0.075, 0.0),
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: screenWidth * 0.18,
                  height: screenHeight * 0.09,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.025),
            ],
          ),
        ),
        Positioned(
          top: (screenHeight * 0.02),
          left: (screenWidth * 0.25),
          child: Text(item.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Positioned(
          bottom: (screenHeight * 0.02),
          left: (screenWidth * 0.25),
          child: Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(item.price * item.amount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
            top: (screenHeight * 0.01),
            right: (screenWidth * 0.02),
            child: Ink(
              height: 30.0,
              width: 30.0,
              child: InkWell(
                borderRadius: BorderRadius.circular(5.0),
                onTap: () {},
                child: const Icon(
                  Icons.delete,
                  size: 20.0,
                  color: Color.fromARGB(255, 49, 48, 77),
                ),
              ),
            )),
        Positioned(
          bottom: (screenHeight * 0.02),
          right: (screenWidth * 0.02),
          child: Row(
            children: [
              Ink(
                width: 24.0,
                height: 24.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 240, 236, 229),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                  ),
                  onTap: () {},
                  child: const Icon(
                    Icons.remove,
                    size: 15.0,
                    color: Color.fromARGB(255, 49, 48, 77),
                  ),
                ),
              ),
              const SizedBox(width: 1.0),
              Container(
                width: 24.0,
                height: 24.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 240, 236, 229),
                ),
                child: Center(
                  child: Text('${item.amount}'),
                ),
              ),
              const SizedBox(width: 1.0),
              Ink(
                width: 24.0,
                height: 24.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 240, 236, 229),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                  onTap: () {},
                  child: const Icon(
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
}
