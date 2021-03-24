import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/ChartBar.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final dayOfWeek = DateTime.now().subtract(
        Duration(days: index),
      );
      double total = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == dayOfWeek.day &&
            recentTransactions[i].date.month == dayOfWeek.month &&
            recentTransactions[i].date.year == dayOfWeek.year) {
          total += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(dayOfWeek).substring(0, 1),
        'amount': total
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (previousSum, element) => previousSum + element['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((tx) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  tx['day'],
                  tx['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (tx['amount'] as double) / totalSpending,
                ),
              );
            }).toList()),
      ),
    );
  }
}
