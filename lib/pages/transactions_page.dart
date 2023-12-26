// transactions.dart

import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Page'),
      ),
      body: Center(
        child: Text('View your transaction history here!'),
      ),
    );
  }
}
