import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TransactionsPage(),
          ],
        ),
      ),
    );
  }
}

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late List<Transaction> transactions;
  late List<Transaction> filteredTransactions;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data dari API
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://gjq3q54r-8080.asse.devtunnels.ms/user/6584637ebe966f9cec6ebce6'));
    if (response.statusCode == 200) {
      // Jika respons sukses, parse data dan simpan dalam list transactions
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> historyData = responseData['data']['history'];
      transactions = historyData.map((data) => Transaction.fromJson(data)).toList();
      filteredTransactions = List.from(transactions);
      // Perbarui UI
      setState(() {});
    } else {
      // Jika respons gagal, tampilkan pesan kesalahan atau lakukan penanganan yang sesuai
      print('Failed to load data: ${response.statusCode}');
    }
  }

  void searchProducts(String query) {
    setState(() {
      filteredTransactions = transactions
          .where((transaction) =>
              transaction.name.toLowerCase().contains(query.toLowerCase()) ||
              transaction.overview.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showProductNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Produk Tidak Ditemukan'),
          content: Text('Maaf, produk yang Anda cari tidak ditemukan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xFFF0ECE5),
        padding: EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.0),
              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF0ECE5),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Color(0xFF31304D)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search, color: Color(0xFF31304D)),
                    ),
                    Expanded(
                      child: Container(
                        height: 30.0,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (query) {
                            searchProducts(query);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.filter_alt, color: Color(0xFF31304D)),
                    ),
                  ],
                ),
              ),
              // Tampilkan data transaksi dari API
              if (filteredTransactions.isEmpty)
                Center(
                  child: Text('Tidak ada produk yang ditemukan'),
                )
              else
                for (Transaction transaction in filteredTransactions)
                  buildTransactionCard(transaction),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTransactionCard(Transaction transaction) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_formatDate(transaction.date)}',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        '${_formatTime(transaction.date)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Icon(Icons.more_vert, color: Color(0xFF31304D)),
                ],
              ),
            ),
          ),
          Divider(
            color: Color(0xFF31304D),
            thickness: 1.5,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 70.0,
                  height: 70.0,
                  color: Colors.grey[200],
                  child: transaction.image.isNotEmpty
                      ? Image.network(
                          transaction.image,
                          fit: BoxFit.cover,
                        )
                      : Placeholder(),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 4.0),
                      Text(
                        transaction.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        transaction.overview,
                        style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'Rp. ${transaction.price}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 255, 255),
                        side: BorderSide(color: Color(0xFF31304D)),
                      ),
                      child: Text(
                        transaction.orderStatus,
                        style: TextStyle(color: Color(0xFF31304D)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getDayOfWeek(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute}';
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}

class Transaction {
  final String name;
  final String overview;
  final String image;
  final int price;
  final String orderStatus;
  final DateTime date;

  Transaction({
    required this.name,
    required this.overview,
    required this.image,
    required this.price,
    required this.orderStatus,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['name'],
      overview: json['overview'],
      image: json['image'],
      price: json['price'],
      orderStatus: json['orderStatus'],
      date: DateTime.parse(json['date']),
    );
  }
}
