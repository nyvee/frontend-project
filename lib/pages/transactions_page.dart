// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_project/components/top_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final userId = Hive.box('myBox').get('userId');

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late List<Transaction> transactions;
  List<Transaction> filteredTransactions = [];
  bool sortByLatest = true;

  @override
  void initState() {
    super.initState();
    // Call the function to fetch data from the API
    fetchData().then((_) {
      // Initialize filteredTransactions after fetchData is complete
      setState(() {
        filteredTransactions = List.from(transactions);
      });
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://ecommerce-api-ofvucrey6a-uc.a.run.app/user/$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> historyData = responseData['data']['history'];
        transactions =
            historyData.map((data) => Transaction.fromJson(data)).toList();
        // Update filteredTransactions as well
        filteredTransactions = List.from(transactions);

        // Update UI
        setState(() {});
      } else {
        print('Failed to load data: ${response.statusCode}');
        // Handle error scenario, e.g., show an error message
      }
    } catch (e) {
      print('Exception during data fetch: $e');
      // Handle exception, e.g., show an error message
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

  Future<void> refreshData() async {
    await fetchData();
    setState(() {
      filteredTransactions = List.from(transactions);
    });
  }

  void toggleSort() {
    setState(() {
      sortByLatest = !sortByLatest;
      if (sortByLatest) {
        filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
      } else {
        filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
      }
    });
  }

  void showProductNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Produk Tidak Ditemukan'),
          content: const Text('Maaf, produk yang Anda cari tidak ditemukan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSortOptions(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1, 165, 0, 0),
      items: <PopupMenuEntry>[
        _buildSortOption('Sort by Latest', true),
        _buildSortOption('Sort by Oldest', false),
        const PopupMenuDivider(),
        _buildSortOption('Sort A-Z', 'A-Z'),
        _buildSortOption('Sort Z-A', 'Z-A'),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          if (value is bool) {
            // Sort by Latest/Oldest
            sortByLatest = value;
            if (sortByLatest) {
              filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
            } else {
              filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
            }
          } else if (value == 'A-Z') {
            // Sort A-Z
            filteredTransactions.sort((a, b) => a.name.compareTo(b.name));
          } else if (value == 'Z-A') {
            // Sort Z-A
            filteredTransactions.sort((a, b) => b.name.compareTo(a.name));
          }
        });
      }
    });
  }

  PopupMenuItem<dynamic> _buildSortOption(String title, dynamic value) {
    return PopupMenuItem<dynamic>(
      value: value,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(title),
        leading: const Icon(Icons.sort),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: 'Transactions',
          showSettingsButton: false,
          showBackButton: false,
        ),
        body: RefreshIndicator(
          onRefresh: refreshData,
          child: Container(
            color: const Color(0xFFF0ECE5),
            padding: const EdgeInsets.all(7.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10.0),
                  // Search Bar
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0ECE5),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: const Color(0xFF31304D)),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search, color: Color(0xFF31304D)),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 30.0,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (query) {
                                searchProducts(query);
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            onPressed: () => showSortOptions(context),
                            icon: const FaIcon(
                              FontAwesomeIcons.filter,
                              size: 16.0,
                              color: Color(0xFF31304D),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Tampilkan data transaksi dari API
                  if (filteredTransactions.isEmpty)
                    const Center(
                      child: Text('Tidak ada produk yang ditemukan'),
                    )
                  else
                    for (Transaction transaction in filteredTransactions)
                      buildTransactionCard(transaction),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildTransactionCard(Transaction transaction) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 1.0,
            margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(transaction.date),
                        style: const TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        _formatTime(transaction.date),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert, color: Color(0xFF31304D)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Material(
                  elevation: 2.0, // Set the elevation here
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(transaction.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(
                        transaction.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        transaction.overview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 13.0, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(transaction.price),
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 4.0),
                                  ),
                                  side: MaterialStateProperty.all(
                                    const BorderSide(
                                      color: Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                  minimumSize:
                                      MaterialStateProperty.all(Size.zero),
                                ),
                                onPressed: () {},
                                child: Text(
                                  transaction.orderStatus,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ])
                    ],
                  ),
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
