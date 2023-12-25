import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  final String name;
  final String overview;
  final String image;
  final double price;

  Product({
    required this.name,
    required this.overview,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      overview: json['overview'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final PageController _recommendedPageController1 = PageController();
  final PageController _recommendedPageController2 = PageController();
  int _currentPage = 0;
  late Timer _timer;
  late List<Product> _recommendedProductsContainer1 = [];
  late List<Product> _recommendedProductsContainer2 = [];
  bool _recommendedProductsLoaded = false;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Product> products = data.map((item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadRecommendedProducts();
  }

  Future<void> _loadRecommendedProducts() async {
    if (!_recommendedProductsLoaded) {
      try {
        final products = await fetchProducts();
        List<Product> shuffledProducts = List.from(products)..shuffle();
        setState(() {
          _recommendedProductsContainer1 = shuffledProducts;
          _recommendedProductsContainer2 = List.from(shuffledProducts)..shuffle();
          _recommendedProductsLoaded = true;
        });
      } catch (e) {
        print('Error loading recommended products: $e');
      }
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    _recommendedPageController1.dispose();
    _recommendedPageController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF0ECE5),
        elevation: 6,
        toolbarHeight: 85.0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0 , vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Color(0xFF31304D)),
                  color: Color(0xFFF0ECE5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF31304D)),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        height : 30.0,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xFF31304D)),
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(Icons.favorite_outline_outlined, color: Color(0xFF31304D)),
              ),
            ),
            SizedBox(width: 16.0),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xFF31304D)),
                color: Colors.transparent,
              ),
              child: Center(
                child: Icon(Icons.notifications_none, color: Color(0xFF31304D)),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        color: Color(0xFFF0ECE5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),

              // Kotak Menu
              Container(
                height: 40.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildMenuBox('All'),
                    buildMenuBox('Men'),
                    buildMenuBox('Women'),
                    buildMenuBox('Kids'),
                    buildMenuBox('Accessories'),
                    buildMenuBox('Seasonal Picks'),
                    buildMenuBox('Sale'),
                  ],
                ),
              ),

              SizedBox(height: 15.0),

              // Kolom Produk yang dapat di-slide
              Container(
                height: 200.0,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 6, // Sesuaikan dengan jumlah gambar yang Anda miliki
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100.0,
                            height: 180.0,
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/gambar${index + 1}.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Text('Product ${index + 1}'),
                            ),
                          );
                        },
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6, // Sesuaikan dengan jumlah gambar yang Anda miliki
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            width: 24.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: (index == _currentPage) ? Color(0xFF31304D) : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Container pertama
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 10.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for you',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF31304D)),
                    ),
                    SizedBox(height: 8.0),
                    // Slide produk
                    if (_recommendedProductsLoaded)
                      Container(
                        width: double.infinity,
                        height: 242.0,
                        child: PageView.builder(
                           controller: PageController(viewportFraction: 0.55),
                          itemCount: _recommendedProductsContainer1.length,
                          itemBuilder: (context, index) {
                            return RecommendedProductCard(
                              productName: _recommendedProductsContainer1[index].name,
                              description: _recommendedProductsContainer1[index].overview,
                              imagePath: _recommendedProductsContainer1[index].image,
                              price: _recommendedProductsContainer1[index].price,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // Container kedua
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 10.0),
                color: Color(0xFF31304D),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for you',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFFF0ECE5)),
                    ),
                    SizedBox(height: 8.0),
                    // Slide produk
                    if (_recommendedProductsLoaded)
                      Container(
                        width: double.infinity,
                        height: 242.0,
                        child: PageView.builder(
                           controller: PageController(viewportFraction: 0.55),
                          itemCount: _recommendedProductsContainer2.length,
                          itemBuilder: (context, index) {
                            return RecommendedProductCard2(
                              productName: _recommendedProductsContainer2[index].name,
                              description: _recommendedProductsContainer2[index].overview,
                              imagePath: _recommendedProductsContainer2[index].image,
                              price: _recommendedProductsContainer2[index].price,
                            );
                          },
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

Widget buildMenuBox(String text) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Color(0xFF31304D)),
      color: Colors.transparent,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF31304D)),
      ),
    ),
  );
}

class RecommendedProductCard2 extends StatelessWidget {
  final String productName;
  final String description;
  final String imagePath;
  final double price;

  RecommendedProductCard2({
    required this.productName,
    required this.description,
    required this.imagePath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.5),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                image: DecorationImage(
                  image: NetworkImage(imagePath), // Menggunakan NetworkImage untuk gambar dari API
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Space with color for Product name, description, price, and icons
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF0ECE5),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
              ),
              child: Column(
                children: [
                  // Product Name
                  Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      productName,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF31304D)),
                    ),
                  ),
                  SizedBox(height: 0.5),
                  // Product Description
                  Container(
                    height: 30.0,
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 12.0, color: Color(0xFF31304D)),
                    ),
                  ),
                  // Price and Love Icon and Cart Icon
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price (Align to the left)
                        Text(
                          'Rp. ${price.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0xFF31304D)),
                        ),
                        // Love Icon and Cart Icon
                        Row(
                          children: [
                            // Love Icon
                            Icon(Icons.favorite_border, color: Color(0xFF31304D)),
                            SizedBox(width: 8.0),
                            // Cart Icon
                            Icon(Icons.shopping_cart, color: Color(0xFF31304D)),
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
    );
  }
}

class RecommendedProductCard extends StatelessWidget {
  final String productName;
  final String description;
  final String imagePath;
  final double price;

  RecommendedProductCard({
    required this.productName,
    required this.description,
    required this.imagePath,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.5),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 130.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                image: DecorationImage(
                  image: NetworkImage(imagePath), // Menggunakan NetworkImage untuk gambar dari API
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Space with color for Product name, description, price, and icons
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF31304D),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
              ),
              child: Column(
                children: [
                  // Product Name
                  Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      productName,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF0ECE5)),
                    ),
                  ),
                  // Product Description
                  Container(
                                        height: 30.0,
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 12.0, color: Color(0xFFF0ECE5)),
                    ),
                  ),
                  // Price and Love Icon and Cart Icon
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price (Align to the left)
                        Text(
                          'Rp. ${price.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0xFFF0ECE5)),
                        ),
                        // Love Icon and Cart Icon
                        Row(
                          children: [
                            // Love Icon
                            Icon(Icons.favorite_border, color: Color(0xFFF0ECE5)),
                            SizedBox(width: 8.0),
                            // Cart Icon
                            Icon(Icons.shopping_cart, color: Color(0xFFF0ECE5)),
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
    );
  }
}

