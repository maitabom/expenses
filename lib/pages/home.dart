import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
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

  Widget getIconButton(IconData icon, VoidCallback action) {
    return Platform.isIOS
        ? GestureDetector(onTap: action, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: action);
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final actions = [
      if (isLandscape)
        getIconButton(_showChart ? Icons.list : Icons.show_chart, () {
          setState(() {
            _showChart = !_showChart;
          });
        }),
      getIconButton(
        Icons.add_circle_outline,
        () => openTransactionModal(context),
      ),
    ];

    final PreferredSizeWidget appBar =
        Platform.isIOS
            ? CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(children: actions),
            )
            : AppBar(title: Text('Despesas Pessoais'), actions: actions);

    final availableHeight =
        MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /* if (isLandscape)
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
              ), */
            if (_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.7 : 0.3),
                child: Chart(recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * 0.7,
                child: TransactionList(transactions, deleteTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
          navigationBar: appBar as ObstructingPreferredSizeWidget,
          child: bodyPage,
        )
        : Scaffold(
          appBar: appBar,
          body: bodyPage,
          floatingActionButton:
              Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                    onPressed: () => openTransactionModal(context),
                    child: Icon(Icons.add),
                  ),
        );
  }
}
