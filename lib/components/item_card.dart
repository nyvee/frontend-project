import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/pages/subpages/product_details_page.dart';

class ItemCard extends StatelessWidget {
  final String productName;
  final String description;
  final String imagePath;
  final int price;
  final Color color1;
  final Color color2;
  final String productId;

  ItemCard({
    required this.productName,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.color1,
    required this.color2,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(productId: productId),
            ),
          );
        },
        child: Card(
          color: color2,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              // Product Image
              Container(
                height: 160.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        productName,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: color1,
                        ),
                      ),
                    ),
                    // Product Description
                    Container(
                      padding:
                          EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                      child: Text(
                        description,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          color: color1,
                        ),
                      ),
                    ),
                    // Price and Icons
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price (Align to the left)
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(price),
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: color1,
                            ),
                          ),
                          // Love Icon and Cart Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Love Icon
                              Icon(Icons.favorite_border, color: color1),
                              SizedBox(width: 8.0),
                              // Cart Icon
                              Icon(Icons.shopping_cart, color: color1),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
