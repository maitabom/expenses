import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.tr, required this.onRemove});

  final Transaction tr;
  final void Function(String p1) onRemove;

  @override
  Widget build(BuildContext context) {
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
        title: Text(tr.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(DateFormat('d MMM y').format(tr.date)),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          onPressed: () => onRemove(tr.id),
        ),
      ),
    );
  }
}
