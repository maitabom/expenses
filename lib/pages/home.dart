import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> transactions = [];

  bool _showChart = false;

  List<Transaction> get recentTransactions {
    return transactions.where((transaction) {
      final datePivot = DateTime.now().subtract(Duration(days: 7));
      return transaction.date.isAfter(datePivot);
    }).toList();
  }

  openTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(addTransaction);
      },
    );
  }

  addTransaction(String title, double value, DateTime date) {
    final pivot = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      transactions.add(pivot);
    });

    Navigator.of(context).pop();
  }

  deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Despesas Pessoais'),
      actions: [
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () => openTransactionModal(context),
        ),
      ],
    );

    final availableHeight =
        MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Exibir Gráfico'),
                Switch(
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                ),
              ],
            ),
            _showChart
                ? SizedBox(
                  height: availableHeight * 0.3,
                  child: Chart(recentTransactions),
                )
                : SizedBox(
                  height: availableHeight * 0.7,
                  child: TransactionList(transactions, deleteTransaction),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openTransactionModal(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
