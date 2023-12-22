import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
class Product {
  final String name;
  final String image;
  final double price;
  final String description;

  Product({required this.name, required this.image, required this.price, required this.description});
}

class Searchh extends StatefulWidget {
  const Searchh({Key? key}): super(key: key);

  @override
  SearchhState createState() => SearchhState();
}

class SearchhState extends State<Searchh>  {
  late List<Product> searchResults = [];

  Future<void> searchProduct(String productName) async {
  final response = await http.get(Uri.parse('https://gjq3q54r-8080.asse.devtunnels.ms/api/products?name=$productName'));

  if (response.statusCode == 200) {
    final dynamic responseData = json.decode(response.body);

    if (responseData is List<dynamic>) {
      final List<Product> filteredResults = responseData
          .where((item) =>
              item['name'].toLowerCase().contains(productName.toLowerCase()))
          .map((item) => Product(
                name: item['name'],
                image: item['image'],
                price: item['price'].toDouble(),
                description: item['description'],
              ))
          .toList();

      setState(() {
        searchResults = filteredResults;
      });

      print('Search results loaded: $searchResults');
    } else if (responseData is Map<String, dynamic>) {
      // Handle the case when the response is a map
      // You might need to extract the necessary information from the map
      // and convert it into a List<Product> as needed.
    }
  } else {
    // Handle error
    print('Failed to load data');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: _buildHeader(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildContent(index),
              childCount: searchResults.length + 1, // Add 1 for the placeholder
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFF0EBE5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color(0xFF31304D),
                          width: 2.2,
                        ),
                        color: const Color(0xFFF0EBE5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFF31304D)),
                          SizedBox(width: 5, height: 0,),
                          Expanded(
                            child: TextField(
                              style: TextStyle(fontSize: 18.0, height: 1.0),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                                isDense: true,
                              ),
                              onSubmitted: (productName) {
                                if (productName.isNotEmpty) {
                                  searchProduct(productName);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 0.0),
                    child: Row(
                      children: [
                        _buildIconContainer(Icons.favorite_border),
                        const SizedBox(width: 18.0),
                        _buildIconContainer(Icons.notifications_none),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 390,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31314D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(
                        color:  Color(0xFF31304D),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.discount, size: 17.0),
                      const SizedBox(width: 5.0),
                      Text(
                        'Promotional Offers',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContent(int index) {
    if (index < searchResults.length) {
      final product = searchResults[index];
      return ListTile(
        title: Text(product.name),
        subtitle: Text(product.description),
        // Other details...
      );
    } else if (index == searchResults.length && searchResults.isNotEmpty) {
    return const SizedBox(
      child: Text('No more results'),
    );
  } else {
    return const SizedBox(
      child: Text('Loading...'),
    );
  }
}

  Widget _buildIconContainer(IconData iconData) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color(0xFF31314D),
          width: 2.2,
        ),
        color: Colors.transparent,
      ),
      child: Center(
        child: Icon(iconData, color: const Color(0xFF31314D)),
      ),
    );
  }
}
