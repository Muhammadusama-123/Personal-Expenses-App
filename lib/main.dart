import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // ye package system chrome k liye zarori hai.

import './widgets/add_transaction.dart';
import './widgets/transactions.list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // flutter k new versions me ye bhi add karna padta hai.
  // // warna kuch devices pe phir ye systemChrome wala feature work nahi karta.
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // is upar wale code se sirf landscape pe app chalegi.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber, // there is no accent swatch.
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Quicksand',
                ),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        amount: 100, date: DateTime.now(), id: 't1', title: 'Easy Load.'),
    Transaction(
        amount: 70, date: DateTime.now(), id: 't3', title: 'Bike Puncture.'),
  ];

  bool _showChart = false; // ye switch se controll hoga.

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
    // jo transactions 7 days se pehle pehle ki hain wo add sirf.
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString(),
        title: txTitle);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void addTxSheet(BuildContext cTx) {
    showModalBottomSheet(
        context: cTx,
        builder: (_) {
          return AddTransactions(_addNewTransactions);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
// ye mediaQuery ka object var me store karadiya or isko build method me top pe rakha hai taake
// jab bhi build method bar bar re run ho to ye final hai ye bar bar change nahi hoga lekin jab
// build method re render hoga to ye nayi value har time create hogi mediaQuery ki or jaga neeche
// paas hojayegi jahan jahan use ki hai. lekin create hone k baad bar bar change nahi hogi isliye
// final rakha hai or jab build re run hoga jab value re create hogi.

    // isko final isliye rakha kiynki each build run pe ham isko bar bar reasign nahi
    // karenge.
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;
    // ye isLandscape har dafa re calculate hoga build pe.
    final appBar = AppBar(
      elevation: 6,
      title: Center(
        child: Text(
          'Personal Expenses',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => addTxSheet(context), // isko build context bhi required isliye
            // it has an anonymas function.
          icon: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ],
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
             mediaQuery.padding.top) *
          0.7,
      child: TransactionsList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar:
          appBar, // appbar ko variable me isliye kiya kiynki isme height se related info
      //hogi.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // if k baad {} ye nahi lagane because ye list k andar wala special if hai.
// agar isLandscape true hoga jabhi row add hogi list me otherwise add nahi hogi.
// ye feature dart 2.2.2 se add houa hai.
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      // val jo hai wo jo switch ki value hogi uski value wo hogi.
                      setState(() {
                        _showChart = val;
                      });
                    }, // ye jo val hai wo bool me hogi depending upon
                    // switch. switch ki value true to val bhi true
                  ),
                  // true pe switch enable hai.
                ],
              ),
            // ab yahan chart or list ka bhi either or case hoga agar ham landscape mode
// me honge warna potrait me donon run karane hain.
// transactions list change nahi hongi bar bar isliye isko final kardiya.
            if (!isLandscape)
              Container(
                // landscape mode me nahi hain to chart container ki height kam ki hai.
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3, // isko 0.4 se 0.3 kiya or phir 0.3 se 1 kiya lekin
                // wo fit nahi horaha tha isliye 0.7 kiya, kiynki hame koi ek cheez
// dikhani hai donon cheezen nahi dikhani jo height ka masla ho.
                child: Chart(_recentTransactions),
              ),
// ye do widgets above each other run honge.
            if (!isLandscape) txListWidget,

            if (isLandscape)
// ye neeche wali ternary expression jab run hogi jab ham landscape mode me honge
// warna upar wala code run hoga.
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7, // isko 0.4 se 0.3 kiya or phir 0.3 se 1 kiya lekin
                      // wo fit nahi horaha tha isliye 0.7 kiya, kiynki hame koi ek cheez
// dikhani hai donon cheezen nahi dikhani jo height ka masla ho.
                      child: Chart(_recentTransactions),
                    )
                  :
                  // prefferd size is for the height of appbar.
                  txListWidget
          ],
        ),
      ),
      floatingActionButton: Platform.isIOS ? Container(
        
      ) : FloatingActionButton(
        onPressed: () => addTxSheet(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
