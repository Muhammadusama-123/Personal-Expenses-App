import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:personal_expenses_app/widgets/chart.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        // ab constraint object se ham dynamically height or width calculate karenge
        // based on constraints. constraint is size of the object that are applied to our costom
        // widget from outside.
        return Column(
          children: [
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                    child: Text(
                  '\Rs: ${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                  ),
                ))),
            SizedBox(height: constraints.maxHeight * 0.05), // 5 %
            Container(
              height: constraints.maxHeight *
                  0.6, // bars ko dynamically size karna hai. overall chart wali jo mediaquery hai
              // wo bhi use karsakte hain or usko apne requirement k mutabiq wale se multiply karwa denge.
              // chart me 0.7 pe error aajaiga isliye saare widgets ko fixed height nahi dynamically
              // calculated height di.
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color:
                          Color.fromRGBO(220, 220, 220, 1), // light grey color.
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
            // fitted box isliye add kara kiynki agar choti device hai ya kam height availabel hai
            // to text usme adjust hosake.
          ],
        );
      },
    );
  }
}
