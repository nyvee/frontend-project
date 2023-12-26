import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransactionsPage(),
    );
  }
}

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool isPaymentOptionsVisible = false;
  String selectedPaymentOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle navigation back
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF0ECE5),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        color: Color(0xFFF0ECE5),
        padding: EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 300.0, // Ganti dengan lebar maksimum yang diinginkan
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              color: Colors.grey[200],
                              child: Icon(Icons.image, size: 36.0),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Nama Produk',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 150.0),
                                          Icon(Icons.delete_outline_outlined, color: Colors.grey), // Ikon hapus
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Text(
                                    'Keterangan',
                                    style: TextStyle(fontSize: 13.0, color: Colors.grey[700]),
                                  ),
                                  SizedBox(height: 12.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp. 100.000',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      // Jumlah barang sejajar dengan harga dan mentok ke kanan
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle button press
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color.fromARGB(255, 255, 255, 255),
                                          side: BorderSide(color: Color(0xFF31304D)),
                                        ),
                                        child: Text(
                                          '2',
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
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.0),

              // Container untuk Delivery dan Payment
              Container(
                color: Color(0xFFECE7D4),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card Delivery
                    Card(
                      color: Color.fromARGB(255, 211, 211, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
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

                    SizedBox(height: 16.0),

                    // Card Payment dengan opsi
                    Card(
                      color: Color.fromARGB(255, 211, 211, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPaymentOptionsVisible = !isPaymentOptionsVisible;
                                    });
                                  },
                                  child: Icon(isPaymentOptionsVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: isPaymentOptionsVisible,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 8.0),
                                  // Opsi Payment
                                  TextButton(
                                    onPressed: () {
                                      _selectPaymentOption('Bank X');
                                    },
                                    child: Text(
                                      'Bank X',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: selectedPaymentOption == 'Bank X' ? FontWeight.bold : FontWeight.normal,
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
                                        fontWeight: selectedPaymentOption == 'COD' ? FontWeight.bold : FontWeight.normal,
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
                                        fontWeight: selectedPaymentOption == 'Pay Later' ? FontWeight.bold : FontWeight.normal,
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
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Selected Payment Option: $selectedPaymentOption',
                                    style: TextStyle(
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
                backgroundColor: Color(0xFFF0ECE5),
                elevation: 0, // Hilangkan shadow pada Appbar
                title: Column(
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
                      primary: Color.fromARGB(255, 255, 255, 255),
                      side: BorderSide(color: Color(0xFF31304D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Ubah nilai sesuai keinginan
                      ),
                    ),
                    icon: Icon(null), // Tambahkan ikon null untuk membuat tombol lonjong
                    label: Text(
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
