import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionList(this.transactions, this.onRemove, {super.key});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
          children: [
            Text(
              "Nenhuma transação cadastradada",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        )
        : ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tr = transactions[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text(
                        NumberFormat.currency(
                          symbol: 'R\$',
                          decimalDigits: 2,
                        ).format(tr.value),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  tr.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(DateFormat('d MMM y').format(tr.date)),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => onRemove(tr.id),
                ),
              ),
            );
          },
        );
  }
}
