import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plan_on/custom/ExpenseCard.dart';
import 'package:plan_on/pages/AddExpense.dart';
import 'package:plan_on/pages/ExpenseHomePage.dart';
import 'package:plan_on/pages/HomePage.dart';
import 'package:plan_on/pages/completedTodo.dart';
import 'package:plan_on/pages/view_expense.dart';
import 'package:plan_on/pages/PieChartPage.dart';

import '../sharedPref.dart';

class ExpenseHomePage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  String phNum = SharedPref.getString("user_ph_no");
  Stream<QuerySnapshot>_stream;

  List<Select> selected=[];
  @override

  String doc_title, doc_type, doc_cat, doc_desc, doc_id, doc_amount;
  
  Widget build(BuildContext context) {
    _stream = FirebaseFirestore.instance.collection("expense"+phNum).orderBy("Date", descending: true).snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Expenses",
            style: TextStyle(
              fontSize: 34,
              color:Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          bottom: PreferredSize(
            child:Align(
              //alignment: Alignment.centerLeft,
              child:Padding(
                padding: const EdgeInsets.only(left:5,bottom: 22,right: 5,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff1d1e26),
                        Color(0xff252041),
                      ])
                  ),

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                        alignment: Alignment.center,
                        //color: Colors.blueGrey,
                        height: 35,
                        width: 165,


                        decoration:BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.blue
                        ),

                        child: Text("Expense list",
                          style: TextStyle(

                            fontSize: 15,
                            color:Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,

                          ),

                        ),
                      ),
                      InkWell(
                        onTap: (){
                          //_startAddNewTransaction(context);
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>PieChartPage()));
                        },
                        child: Container(
                          // color: Colors.blueGrey,
                          alignment: Alignment.center,
                          height: 35,
                          // decoration:BoxDecoration(
                          //   gradient: LinearGradient(colors: [
                          //     Color(0xff1d1e26),
                          //     Color(0xff252041),
                          //   ])
                          // ),
                          child: Text("Analysis",
                            style: TextStyle(

                              fontSize: 15,
                              color:Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(55),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: [

            BottomNavigationBarItem(

              icon:InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder)=>HomePage()));

                },

                child: Column(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),

                      child: Icon(
                        Icons.view_list_outlined,
                        size: 32,
                        color: Colors.white,

                      ),

                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("ToDo",
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder)=>AddExpense()));
                },

                child: Column(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),

                      child: Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Add Expense",
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
                        color: Colors.green,

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
          ],
        ),
        body:StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child:
                CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder:(context,index){
                  IconData iconData;
                  Color iconColor;

                  Map<String,dynamic>document
                                =snapshot.data.docs[index].data() as Map<String,dynamic>;

                  doc_title = document["title"];
                  doc_type = document["task"];
                  doc_cat = document["Category"];
                  doc_desc = document["description"];
                  doc_id = snapshot.data.docs[index].id;
                  //doc_amount = document["amount"];

                  switch(document["Category"]){
                    case "Personal":
                      iconData=Icons.person_add_alt_1_rounded;
                      iconColor=Colors.red;
                      break;
                    case "Savings Tax Insurance":
                      iconData=Icons.savings;
                      iconColor=Colors.teal;
                      break;
                    case "Shopping":
                      iconData=Icons.shopping_bag;
                      iconColor=Colors.blue;
                      break;
                    case "Grocery and Home utilities":
                      iconData=Icons.local_grocery_store;
                      iconColor=Colors.green;
                      break;
                    case "Medical":
                      iconData=Icons.medical_services;
                      iconColor=Colors.green;
                      break;
                    case "Others":
                      iconData=Icons.medical_services;
                      iconColor=Colors.green;
                      break;
                    default:
                      iconData=Icons.category;
                      iconColor=Colors.red;
                      break;
                  }
                  selected.add(
                    Select(id:snapshot.data.docs[index].id,checkValue: false),
                  );
                  return InkWell(

                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder)=>ViewExpense(
                            document: document,
                            id:snapshot.data.docs[index].id,
                          )));
                    },
                    child: ExpenseCard(
                      title:document["title"],
                      date:document["Date"].toDate(),
                      amount:document["amount"],
                      iconBGColor: Colors.white,
                      iconColor: iconColor,
                      iconData: iconData,
                      //time: "10 AM",
                      index:index,
                      onChange:onChange,
                    ),
                  );

                },
              );
            }

        ),

      ),
    );
  }

  void onChange(index)
  {
  //   setState(() {
  //     selected[index].checkValue=!selected[index].checkValue;
  //
  //     //Send to completed list
  //     FirebaseFirestore.instance.collection("TodoCompleted").add(
  //         {"title": doc_title,
  //           "task": doc_type,
  //           "Category": doc_cat,
  //           "description": doc_desc,
  //         });
  //     //Navigator.pop(context);
  //
  //     Fluttertoast.showToast(
  //       msg: "Done",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       //timeInSecForIos: 1
  //     );
  //
  //     //Delete
  //     FirebaseFirestore.instance
  //         .collection("Todo")
  //         .doc(doc_id)
  //         .delete()
  //         .then((value){
  //       // Navigator.push(context,
  //       //     MaterialPageRoute(builder: (builder)=>HomePage()));
  //     });
  //
  //     Fluttertoast.showToast(
  //       msg: "Deleted",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       //timeInSecForIos: 1
  //     );
  //
  //   });
  //
  //
  }
}

class Select
{
  String id;
  bool checkValue=false;
  Select({this.id,this.checkValue});
}