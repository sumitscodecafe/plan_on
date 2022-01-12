import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:plan_on/model/ExpenseModel.dart';
import 'package:plan_on/model/HistoryModel.dart';
import '../main.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../sharedPref.dart';
import 'ExpenseHistoryPage.dart';
import 'ExpenseHomePage.dart';

class ExpenseHistoryPage extends StatefulWidget {
  String get id => null;

  @override
  _ExpenseHistoryState createState() {
    return _ExpenseHistoryState();
  }
}

class _ExpenseHistoryState extends State<ExpenseHistoryPage> {
  List<charts.Series<HistoryModel, String>> _seriesPieData;
  List<HistoryModel> mydata;
  String phNum = SharedPref.getString("user_ph_no");
  Stream<QuerySnapshot> _stream;

  _generateData(mydata) {
    _seriesPieData = List<charts.Series<HistoryModel, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (HistoryModel expense, _) => expense.month,
        measureFn: (HistoryModel expense, _) => expense.total,
        colorFn: (HistoryModel expense, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
        id: 'barchart'+phNum,
        data: mydata,
        labelAccessorFn: (HistoryModel row, _) => "${row.total}",
      ),
    );
  }

  int getId() {
    return int.parse(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Expense History",
            style: TextStyle(
              fontSize: 25,
              color:Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),


        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: [

            BottomNavigationBarItem(
              icon:InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Expanded(
                        child: AlertDialog(

                          title: Text('Warning!'),
                          content: Text('It will permanently delete Barchart data.'),
                          actions: [
                            FlatButton(
                              textColor: Colors.black,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('CANCEL'),
                            ),
                            FlatButton(
                              textColor: Colors.black,
                              onPressed: () {
                                deleteHistory();
                                Fluttertoast.showToast(
                                  msg: "History cleared!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  //timeInSecForIos: 1
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('PROCEED'),
                            ),
                          ],
                        ),

                      );
                    },
                  );




                },
                child: Column(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:Colors.blueAccent,
                      ),

                      child: Icon(
                        Icons.auto_delete_outlined,
                        size: 32,
                        color: Colors.white,
                      ),

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("RESET",
                      style: TextStyle(
                        fontSize: 10,
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              title: Container(),
            ),

            BottomNavigationBarItem(
              icon:InkWell(
                onTap: (){

                },
                child: Column(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:Colors.green,
                      ),

                      child: Icon(
                        Icons.history,
                        size: 32,
                        color: Colors.white,
                      ),

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("History",
                      style: TextStyle(
                        fontSize: 10,
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              title: Container(),
            ),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    _stream = FirebaseFirestore.instance.collection("barchart"+phNum).orderBy("sort_order").snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<HistoryModel> expense = snapshot.data.docs.map((documentSnapshot) => HistoryModel.fromMap(documentSnapshot.data())).toList();
          return _buildChart(context, expense);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<HistoryModel> taskdata) {
    mydata = taskdata;
    DateTime now = new DateTime.now();

    String year = now.year.toString();

    String resetDate = SharedPref.getString("resetDate");
    if(resetDate == "0")
      resetDate = "Never";
    else
      resetDate = resetDate.substring(0, 10);

    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Monthly Expense Preview: '+year,

                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Last Reset on: '+resetDate,

                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(

                child: charts.BarChart(_seriesPieData, animate: true),
                //     animate: true,
                //     animationDuration: Duration(seconds: 1),
                //     behaviors: [
                //       new charts.DatumLegend(
                //         outsideJustification:
                //         charts.OutsideJustification.endDrawArea,
                //         horizontalFirst: false,
                //         desiredMaxRows: 3,
                //         cellPadding:
                //         new EdgeInsets.only(right: 4.0, bottom: 4.0,top:4.0),
                //         entryTextStyle: charts.TextStyleSpec(
                //             color: charts.MaterialPalette.purple.shadeDefault,
                //             fontFamily: 'Georgia',
                //             fontSize: 12),
                //       )
                //     ],
                //     defaultRenderer: new charts.ArcRendererConfig(
                //         arcWidth: 100,
                //         arcRendererDecorators: [
                //           new charts.ArcLabelDecorator(
                //               labelPosition: charts.ArcLabelPosition.inside)
                //         ])
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteHistory() async {
    var collections = FirebaseFirestore.instance
        .collection("barchart"+phNum);
    var snapshots = await collections.get();
    for(var doc in snapshots.docs)
      await doc.reference.delete();

    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    for(var i = 0; i < 12; i++)
      SharedPref.putString(months[i], "0");

    DateTime now = new DateTime.now();
    String resetDate = now.toString();
    SharedPref.putString("resetDate", resetDate);


  }
}
