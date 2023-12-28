// ignore_for_file: avoid_print, unused_element

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/pages/subpages/product_details_page.dart';

class Product {
  final String name;
  final String image;
  final double price;
  final String overview;
  final String id;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.overview,
    required this.id,
  });
}

class Searchh extends StatefulWidget {
  final String? searchInput;

  const Searchh({Key? key, this.searchInput}) : super(key: key);

  @override
  SearchhState createState() => SearchhState();
}

class SearchhState extends State<Searchh> {
  late List<Product> searchResults = [];
  bool hasSearched = false;
  bool noResults = false;

  @override
  void initState() {
    super.initState();
    // Access the searchInput from the widget property
    final String? searchInput = widget.searchInput;
    if (searchInput != null && searchInput.isNotEmpty) {
      // Call your searchProduct method with the searchInput
      searchProduct(searchInput).then((results) {
        setState(() {
          searchResults = results;
        });
        print('Search results loaded: $searchResults');
      });
    }
  }

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
        if (i + 2 < products.length)
          null
        else
          null, // Add an extra null if it's the last product
      ]);
    }
    return groupedProducts;
  }

  Future<List<Product>> searchProduct(String productName) async {
    final response = await http.get(Uri.parse(
        'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products?name=$productName'));

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
                id: item['_id'] ?? '',
                name: item['name'],
                image: item['image'] ?? '',
                price: item['price']?.toDouble() ?? 0.0,
                overview: item['overview'] ?? '',
              ))
          .toList();

      setState(() {
        searchResults = filteredResults;
        hasSearched = true;
        noResults =
            filteredResults.isEmpty; // Set noResults based on filteredResults
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
            padding: const EdgeInsets.fromLTRB(
                2.0, 20.0, 0.0, 0.0), // Add padding to the SliverPadding
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = searchResults[index];
                  return _buildProductCard(product);
                },
                childCount: searchResults.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  searchResults.isEmpty ? 'No results' : 'No more results',
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
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
            offset: const Offset(0, -3), // Changes position of shadow
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
                            const Icon(Icons.search, color: Color(0xFF31304D)),
                            const SizedBox(
                              width: 5,
                              height: 0,
                            ),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 18.0, height: 1.2),
                                decoration: const InputDecoration(
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
                                      print(
                                          'Search results loaded: $searchResults');
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
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0), // Adjust the margin as needed
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press if needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31314D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
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
      return const SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: SizedBox(
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
        child: FaIcon(iconData, color: const Color(0xFF31314D)),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(productId: product.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: const Color(0xFF31314D),
            width: MediaQuery.of(context).size.width * 0.47,
            height: MediaQuery.of(context).size.width * 0.69,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        ).format(product.price),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          FaIcon(
                            FontAwesomeIcons.cartShopping,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
