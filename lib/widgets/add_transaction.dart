import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactions extends StatefulWidget {
  final Function addTx;
  AddTransactions(this.addTx);

  @override
  State<AddTransactions> createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  late DateTime? _selectedDate = null;

  dynamic _addNewTx() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
          2021), // agar sirf year jese 2021 to 1st jan of 2021 se date start.
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          // padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  labelStyle: TextStyle(
                    fontSize: 23,
                    fontFamily: 'OpenSans',
                  ),
                ),
                controller: _titleController,
                onSubmitted: (_) => _addNewTx(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  labelStyle: TextStyle(
                    fontSize: 23,
                    fontFamily: 'OpenSans',
                  ),
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _addNewTx(),
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: _addNewTx,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
