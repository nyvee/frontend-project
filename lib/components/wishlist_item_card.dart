import 'package:flutter/material.dart';
import 'package:frontend_project/pages/subpages/product_details_page.dart';
import 'package:intl/intl.dart';

class WishlistItem {
  final String productid;
  final String name;
  final String overview;
  final String imageUrl;
  final int price;
  final String id;

  WishlistItem({
    required this.productid,
    required this.name,
    required this.overview,
    required this.imageUrl,
    required this.price,
    required this.id,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productid: json['productid'],
      name: json['name'],
      overview: json['overview'],
      imageUrl: json['image'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

Widget buildWishlistItemCard(WishlistItem item, double screenWidth,
    double screenHeight, BuildContext context) {
  return InkWell(
    onTap: () {
      // Arahkan ke halaman selanjutnya dengan membawa parameter productid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(productId: item.productid),
        ),
      );
    },
    child: Card(
      margin: EdgeInsets.fromLTRB(
          screenWidth * 0.075, screenHeight * 0.025, screenWidth * 0.075, 0.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(screenHeight * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.18,
                  height: screenHeight * 0.09,
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
                SizedBox(width: screenWidth * 0.025),
              ],
            ),
          ),
          Positioned(
            top: (screenHeight * 0.02),
            left: (screenWidth * 0.25),
            child:
                Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Positioned(
            bottom: (screenHeight * 0.02),
            left: (screenWidth * 0.25),
            child: Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(item.price),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
