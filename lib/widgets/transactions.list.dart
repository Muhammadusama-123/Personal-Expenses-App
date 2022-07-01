import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final Function deleteTx;
  final List<Transaction> transactions;
  TransactionsList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return

        // is height ko multiply karo
        // zero ya one se. 1 means full height and zero means 0 height.
        // 0.6 means 60% of height.
        // .ofcontext se pata chalega k konsa size available hai.
        // modren devices ki screen density ziyada wo images ko load karne me help.
        transactions.isEmpty
            ? LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    children: [
                      Text(
                        'No transactions added yet!',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          height: constraints.maxHeight * 0.6,
                          child: Image.asset('assets/images/waiting.png',
                              fit: BoxFit.cover)),

                      // BoxFit ek container me rakh deta hai image ko to hamne container
                      // height 250 rakh di.
                    ],
                  );
                },
              )
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      leading: Container(
                        // height and width are double of radius. circle avatar k saath ye likhna hai.
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple[500],
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\Rs ${transactions[index].amount}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                      ),
                      // CircleAvatar(
                      //   radius: 32,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(6),
                      //     child: FittedBox(
                      //         child: Text('\Rs: ${transactions[index].amount}',
                      //         style: TextStyle(
                      //           fontSize: 30,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //         )),
                      //   ),
                      // ),
                      title: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date),
                        style: TextStyle(
                          color: Colors.grey[900],
                        ),
                      ),
                      trailing: MediaQuery.of(context).size.width > 460
// emulator ki width shahyad 411 tak hai isi liye isse neeche rakh rahe to potrait pe textbutton
// show ho raha. lekin landscape mode pe height badh jaati hai.
                          ? TextButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        content: Text(
                                          'Are  you want to delete this transaction?',
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 20,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.purple),
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                width: 2,
                                                color: Colors.black,
                                              )),
                                            ),
                                            onPressed: () {
                                              deleteTx(transactions[index].id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          TextButton(
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(
                                                BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('No'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).errorColor,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            content: Text(
                                              'Are  you want to delete this transaction?',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 20,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.purple),
                                                  side:
                                                      MaterialStateProperty.all(
                                                          BorderSide(
                                                    width: 2,
                                                    color: Colors.black,
                                                  )),
                                                ),
                                                onPressed: () {
                                                  deleteTx(
                                                      transactions[index].id);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              TextButton(
                                                style: ButtonStyle(
                                                  side:
                                                      MaterialStateProperty.all(
                                                    BorderSide(
                                                      width: 1,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).errorColor,
                                  )),
                            ),
                    ),
                  );
                },
              );
  }
}
