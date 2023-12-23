import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

class Product {
  final String name;
  final String image;
  final double price;
  final String overview;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.overview,
  });
}

class Searchh extends StatefulWidget {
  const Searchh({Key? key}) : super(key: key);

  @override
  SearchhState createState() => SearchhState();
}

class SearchhState extends State<Searchh> {
 late List<Product> searchResults = [];
  bool hasSearched = false;
  bool noResults = false;


 List<String> splitAfterNChars(String str, int n) {
   List<String> result = [];
   for (int i = 0; i < str.length; i += n) {
     result.add(str.substring(i, i + n));
   }
   return result;
 }

List<List<Product?>> groupProducts(List<Product> products) {
   var groupedProducts = <List<Product?>>[];
   for (var i = 0; i < products.length; i += 2) {
     groupedProducts.add([
       products[i],
       if (i + 1 < products.length) products[i + 1] else null,
       if (i + 2 < products.length) null else null, // Add an extra null if it's the last product
     ]);
   }
   return groupedProducts;
 }


  Future<List<Product>> searchProduct(String productName) async {
    final response = await http.get(Uri.parse(
        'https://gjq3q54r-8080.asse.devtunnels.ms/api/products?name=$productName'));

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      print('Search API Response: $responseData');

      List<dynamic> productList = [];

      if (responseData is List<dynamic>) {
        productList = responseData;
      } else if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data') &&
          responseData['data'] is List<dynamic>) {
        productList = responseData['data'];
      }

      final List<Product> filteredResults = productList
          .where((item) =>
              item['name'] != null &&
              item['name'].toLowerCase().contains(productName.toLowerCase()))
          .map((item) => Product(
                name: item['name'],
                image: item['image'] ?? '',
                price: item['price']?.toDouble() ?? 0.0,
                overview: item['overview'] ?? '',
              ))
          .toList();

      setState(() {
        searchResults = filteredResults;
        hasSearched = true;
        noResults = filteredResults.isEmpty; // Set noResults based on filteredResults
      });

      return filteredResults;
    }

    // If there's an error, return an empty list
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE5),
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: _buildHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 15.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if ((index >= groupProducts(searchResults).length ||
                          !hasSearched) &&
                      hasSearched) {
                    return Center(
                            child: Text(
                              noResults
                                ? 'No results'
                                : 'No more results',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                              ),
                            ),
                          );
                  } else if (groupProducts(searchResults).isEmpty) {
                    return Center();
                  } else {
                    var productPair =
                        groupProducts(searchResults)[index];
                    return Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: productPair
                          .map((product) => product != null
                              ? _buildProductCard(product)
                              : Spacer())
                          .toList(),
                    );
                  }
                },
                childCount: groupProducts(searchResults).length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildHeader() {
 return Container(
   decoration: BoxDecoration(
     boxShadow: [
       BoxShadow(
         color: Colors.grey.withOpacity(0.5), // Color of shadow
         spreadRadius: 5, // Spread radius
         blurRadius: 7, // Blur radius
         offset: Offset(0, -3), // Changes position of shadow
       ),
     ],
   ),
   child: Container(
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12.0),
                                isDense: true,
                              ),
                              onSubmitted: (productName) {
                                if (productName.isNotEmpty) {
                                  searchProduct(productName).then((results) {
                                    setState(() {
                                      searchResults = results;
                                    });
                                    print('Search results loaded: $searchResults');
                                  });
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
                        color: Color(0xFF31304D),
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
     ),
    );
  }

  Widget _buildContent(int index) {
 print('Index: $index, SearchResults length: ${searchResults.length}');
 if (index < searchResults.length) {
 final product = searchResults[index];
 return _buildProductCard(product);
 } else if (index == searchResults.length && searchResults.isNotEmpty) {
 // Use SliverToBoxAdapter for custom content
 return SliverToBoxAdapter(
 child: Align(
  alignment: Alignment.center,
  child: Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Container(
      width: double.infinity,
      child: Text('No more results'),
    ),
  ),
 ),
 );
 } else {
 return const SliverToBoxAdapter(
 child: SizedBox(height: 20.0), // Empty SliverToBoxAdapter for spacing
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

  Widget _buildProductCard(Product product) {
  final formatter = NumberFormat.currency(
    symbol: 'Rp ',
    locale: 'id_ID',
    decimalDigits: 0,
  );

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Card(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Container(
            color: const Color(0xFF31314D),
            width: 190.0,
            height: 280.0,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 170.0,
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  product.name,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            product.overview,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '${formatter.format(product.price)}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: 25.0,
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle button press here
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                'Check Out',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                 Positioned(
                bottom : 25.0,
                right: 20.0,
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: IconButton(
                    onPressed: () {
                      // Handle cart icon button press here
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ),
               ),
                Positioned(
                  bottom: 25.0,
                  right: 50.0,
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: IconButton(
                      onPressed: () {
                        // Handle love icon button press here
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}



}