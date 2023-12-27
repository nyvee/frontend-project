// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frontend_project/components/top_app_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isPaymentOptionsVisible = false;
  String selectedPaymentOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
          title: 'Checkout', showSettingsButton: false, showBackButton: true),
      body: Container(
        color: const Color(0xFFF0ECE5),
        padding: const EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth:
                        300.0, // Ganti dengan lebar maksimum yang diinginkan
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 36.0),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Nama Produk',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 150.0),
                                          Icon(Icons.delete_outline_outlined,
                                              color: Colors.grey), // Ikon hapus
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp. 100.000',
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      // Jumlah barang sejajar dengan harga dan mentok ke kanan
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle button press
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          side: const BorderSide(
                                              color: Color(0xFF31304D)),
                                        ),
                                        child: const Text(
                                          '2',
                                          style: TextStyle(
                                              color: Color(0xFF31304D)),
                                        ),
                                      ),
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

              const SizedBox(height: 16.0),

              // Container untuk Delivery dan Payment
              Container(
                color: const Color(0xFFECE7D4),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card Delivery
                    Card(
                      color: const Color.fromARGB(255, 211, 211, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Delivery',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Nomor Telepon: XXX-XXXX-XXXX',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Alamat: Jalan XXX No. XX',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Card Payment dengan opsi
                    Card(
                      color: const Color.fromARGB(255, 211, 211, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Payment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPaymentOptionsVisible =
                                          !isPaymentOptionsVisible;
                                    });
                                  },
                                  child: Icon(
                                      isPaymentOptionsVisible
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: isPaymentOptionsVisible,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 8.0),
                                  // Opsi Payment
                                  TextButton(
                                    onPressed: () {
                                      _selectPaymentOption('Bank X');
                                    },
                                    child: Text(
                                      'Bank X',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                            selectedPaymentOption == 'Bank X'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _selectPaymentOption('COD');
                                    },
                                    child: Text(
                                      'COD',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                            selectedPaymentOption == 'COD'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _selectPaymentOption('Pay Later');
                                    },
                                    child: Text(
                                      'Pay Later',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                            selectedPaymentOption == 'Pay Later'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: selectedPaymentOption.isNotEmpty,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Selected Payment Option: $selectedPaymentOption',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Appbar pada bagian paling bawah
              AppBar(
                backgroundColor: const Color(0xFFF0ECE5),
                elevation: 0, // Hilangkan shadow pada Appbar
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp. 99.999.999',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Buy button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      side: const BorderSide(color: Color(0xFF31304D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Ubah nilai sesuai keinginan
                      ),
                    ),
                    icon: const Icon(
                        null), // Tambahkan ikon null untuk membuat tombol lonjong
                    label: const Text(
                      'Buy',
                      style: TextStyle(color: Color(0xFF31304D)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectPaymentOption(String option) {
    setState(() {
      selectedPaymentOption = option;
      isPaymentOptionsVisible = false;
    });
  }
}
