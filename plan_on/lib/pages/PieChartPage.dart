import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plan_on/model/ExpenseModel.dart';
import 'package:plan_on/sharedPref.dart';
import '../main.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'ExpenseHistoryPage.dart';
import 'ExpenseHomePage.dart';

class PieChartPage extends StatefulWidget {
  @override
  _PieChartState createState() {
    return _PieChartState();
  }
}

class _PieChartState extends State<PieChartPage> {
  List<charts.Series<ExpenseModel, String>> _seriesPieData;
  List<ExpenseModel> mydata;
  String phNum = SharedPref.getString("user_ph_no");
  _generateData(mydata) {
    _seriesPieData = List<charts.Series<ExpenseModel, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (ExpenseModel expense, _) => expense.category,
        measureFn: (ExpenseModel expense, _) => expense.total,
        colorFn: (ExpenseModel expense, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(expense.colorVal))),
        id: 'piechart'+phNum,
        data: mydata,
        labelAccessorFn: (ExpenseModel row, _) => "${row.total}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Expense Analysis",
            style: TextStyle(
              fontSize: 20,
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
                  //List<> myList = List<>();
                  //myList.add(32);
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ExpenseHomePage()));
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
                          Icons.attach_money_outlined,
                        size: 32,
                        color: Colors.white,
                      ),

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Expense",
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
                  //List<> myList = List<>();
                  //myList.add(32);
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ExpenseHistoryPage()));
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pie_chart'+phNum).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<ExpenseModel> expense = snapshot.data.docs.map((documentSnapshot) => ExpenseModel.fromMap(documentSnapshot.data())).toList();
          return _buildChart(context, expense);
        }
      },
    );
  }
  Widget _buildChart(BuildContext context, List<ExpenseModel> taskdata) {
    mydata = taskdata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Amount spent on Daily expense',

                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 3,
                        cellPadding:
                        new EdgeInsets.only(right: 4.0, bottom: 4.0,top:4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 12),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
