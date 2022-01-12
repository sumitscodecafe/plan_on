import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../sharedPref.dart';

class AddExpense extends StatefulWidget {

  @override
  State<StatefulWidget> createState()=>_AddExpenseState();
}

class _AddExpenseState extends State<AddExpense>{
  TextEditingController _expenseController =TextEditingController();
  TextEditingController _amountController =TextEditingController();
  String type ="", category ="", colorVal="";
  DateTime _selectedDate;
  int _selectedMonth;
  String phNum = SharedPref.getString("user_ph_no");

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff1d1e26),
                Color(0xff252041),
              ])
          ),
          child:SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                IconButton(onPressed: () {
                  Navigator.pop(context);
                },
                  icon: Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create",
                        style: TextStyle(
                          fontSize: 33,
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("New Expense",
                        style: TextStyle(
                          fontSize: 33,
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      label("Title"),
                      SizedBox(
                        height: 12,
                      ),
                      title(),
                      SizedBox(
                        height: 30,
                      ),
                      // label("Task Type"),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      // Row(
                      //   children: [
                      //     taskSelect("Important",0xff2664fa),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     taskSelect("Planned",0xff2bc8d9),
                      //   ],
                      // ),
                      SizedBox(
                        height: 12,
                      ),
                      label("Amount"),
                      SizedBox(
                        height: 12,
                      ),
                      amount(),

                      Container(
                        height: 70,
                        child: Row(
                          children: <Widget>[
                            Expanded(

                              child: Text(
                                _selectedDate == null
                                    ? 'No Date Chosen!'
                                    : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color:Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FlatButton(
                              textColor: Colors.white,
                              //backgroundColor: category==label? Colors.white :Color(0xff234ebd),
                              //TODO: ADD color here
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,

                                  )
                              ),
                              child: Text(
                                'Choose Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _presentDatePicker,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      label("Category"),
                      SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        runSpacing: 0,
                        children: [
                          categorySelect("Personal","0xffff6d6e"),
                          SizedBox(
                            width: 10,
                          ),
                          categorySelect("Savings Tax Insurance","0xfff29732"),
                          SizedBox(
                            width: 10,
                          ),
                          categorySelect("Shopping","0xff6557ff"),
                          SizedBox(
                            width: 10,
                          ),

                          categorySelect("Medical","0xff2bc8d9"),
                          SizedBox(
                            width: 10,
                          ),

                          categorySelect("Grocery and Home utilities","0xff234ebd"),
                          SizedBox(
                            width: 30,
                          ),
                          categorySelect("Others","0xfffdbe19"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      button(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );

  }

  void addPieChartData(key, colorVal, amount) async{

    await SharedPref.getInstance();

    //FORMAT OF sh_pf = docId + total_aomount
    String sh_pf = SharedPref.getString(key);
    int total;

    //SharedPref.putString(key, total.toString()+amount.toString());
    CollectionReference ref = FirebaseFirestore.instance.collection("pie_chart"+phNum);

    if(sh_pf != "0") {  //value of sh_pf == 0 if not set/created (i.e. default val)
      total = int.parse(sh_pf.substring(20)); //previous total
      total += amount;  //new total
      String keyId = sh_pf.substring(0, 20);

      //ref.snapshots().asyncMap((event) => )
      ref.doc(keyId).update(({
        "category": key,
        "total": total,
        "colorVal": colorVal,
      }));
    }
    if(sh_pf == "0"){
      String docId = ref.doc().id;
      ref.doc(docId).set({
        "category": key,
        "total": amount,
        "colorVal": colorVal,
      });
      //total = docId + total_amount
      SharedPref.putString(key, docId+amount.toString());
    }
  }

  void addBarChartData(month, amount) async{
    String month_Str;

    switch(month){
      case 1:
        month_Str = "Jan";
        break;
      case 2:
        month_Str = "Feb";
        break;
      case 3:
        month_Str = "Mar";
        break;
      case 4:
        month_Str = "Apr";
        break;
      case 5:
        month_Str = "May";
        break;
      case 6:
        month_Str = "Jun";
        break;
      case 7:
        month_Str = "Jul";
        break;
      case 8:
        month_Str = "Aug";
        break;
      case 9:
        month_Str = "Sep";
        break;
      case 10:
        month_Str = "Oct";
        break;
      case 11:
        month_Str = "Nov";
        break;
      case 12:
        month_Str = "Dec";
        break;
      default:
        month_Str = "null";
        break;
    }

    await SharedPref.getInstance();

    //FORMAT OF sh_pf = docId + total_aomount
    String sh_pf = SharedPref.getString(month_Str);
    int total;

    //SharedPref.putString(key, total.toString()+amount.toString());

    CollectionReference ref;

    if(sh_pf != "0") {
      ref = FirebaseFirestore.instance.collection("barchart"+phNum);
      total = int.parse(sh_pf.substring(20)); //previous total
      total += amount;  //new monthly total
      String keyId = sh_pf.substring(0, 20);  //doc ID

      ref.doc(keyId).update(({
        "sort_order": month,
        "month": month_Str,
        "total": total,
        "colorVal": colorVal,
      }));
    }else{ //value of sh_pf == 0 if not set/created (i.e. default val)
      ref = FirebaseFirestore.instance.collection("barchart"+phNum);
      String docId = ref.doc().id;
      SharedPref.putString(month_Str, docId+amount.toString());

      ref.doc(docId).set({
        "sort_order": month,
        "month": month_Str,
        "total": amount,
        "colorVal": colorVal,
      });
      //total = docId + total_aomount

    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _selectedMonth = pickedDate.month;
      });
    });
    print('...');
  }

  Widget button(){
    return InkWell(
      onTap: (){
        String phNum = SharedPref.getString("user_ph_no");
        //FirebaseFirestore.instance.collection("tasks").doc("1").collection("12345").add(
        FirebaseFirestore.instance.collection("expense"+phNum).add(
            {"title":_expenseController.text,
            "amount":int.parse(_amountController.text),
              "category":category,
            "colorVal":colorVal,
            "Date":_selectedDate,
            });

        addPieChartData(category, colorVal, int.parse(_amountController.text));
        addBarChartData(_selectedMonth, int.parse(_amountController.text));

        Navigator.pop(context);

      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xff0e2987),
                Color(0xff0526cb),
              ],
            )
        ),
        child: Center(child: Text("ADD EXPENSE",
          style: TextStyle(
            fontSize: 15,
            color:Colors.white,
            fontWeight: FontWeight.w600,

          ),
        ),
        ),
      ),
    );
  }

  Widget amount(){
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _amountController,
        // validator: (value){
        //   if (value.isEmpty){
        //     Fluttertoast.showToast(
        //       msg: "Please Enter Amount!",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       //timeInSecForIos: 1
        //     );
        //     return "msg";
        //   }
        //   return null;
        // },
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Add amount",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding:EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget taskSelect(String label,int color){
    return InkWell(
      onTap: (){
        setState(() {
          type=label;
        });

      },
      child: Chip(
        backgroundColor: type==label? Colors.white :Color(color),


        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            )
        ),

        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 15,
          color:type==label? Colors.black :Colors.white,
          fontWeight: FontWeight.w600,

        ),



        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }
  Widget categorySelect(String label,String color){
    return InkWell(
      onTap: (){
        setState(() {
          category=label;
          colorVal = color;
        });

      },
      child: Chip(
        backgroundColor: category==label? Colors.white :Color(0xff234ebd),

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            )
        ),
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 15,
          color:category==label? Colors.black :Colors.white,
          fontWeight: FontWeight.w600,

        ),



        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }


  Widget title(){
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _expenseController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding:EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget label(String label){
    return Text(
      label,
      style: TextStyle(
        fontSize: 16.5,
        color:Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}


