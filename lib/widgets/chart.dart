import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bars.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);

      return {
        'Day': DateFormat.E().format(weekDay).substring(0, 3),
        'Amount': totalSum, // 9.99 ek din ki transaction ki total spending hai.
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['Amount'] as double); // yahi sum wapis phir input jayega .fold wale me.
    }); // 2nd argument me jo value return hogi
    // wo starting value me add. har item jo hai groupedTransactionValues uspe nayi value return.
    // item is the element we are looking at.
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['Day'] as String,
                data['Amount'] as double,
                totalSpending == 0.0 ? 0.0 : (data['Amount'] as double) / totalSpending,
                // is ratio se ye pata chalega k total week ki spending me se ek din me kitna spend kara.
              ),
            );
          }).toList()),
        ),
    );
  }
}
