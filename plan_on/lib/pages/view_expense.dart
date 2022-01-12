import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../sharedPref.dart';

class ViewExpense extends StatefulWidget {
  ViewExpense({Key key, this.document, this.id}): super(key: key);
  final Map<String,dynamic>document;
  final String id;

  @override
  State<StatefulWidget> createState()=>_ViewExpenseState();
}



class _ViewExpenseState extends State<ViewExpense> {
  TextEditingController _expenseController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String category;
  bool edit = false;

  String phNum = SharedPref.getString("user_ph_no");

  @override
  void initState() {
    super.initState();
    String title = widget.document["title"] == null
        ? "No Title"
        : widget.document["title"];
    _expenseController = TextEditingController(text: title);
    _amountController = TextEditingController(text: widget.document["amount"].toString());
    category = widget.document["Category"];
  }

  int getId() {
    return int.parse(widget.id);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xff1d1e26),
                  Color(0xff252041),
                ])
            ),
            child: SingleChildScrollView(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {
                            FirebaseFirestore.instance
                                .collection("expense"+phNum)
                                .doc(widget.id)
                                .delete()
                                .then((value) {
                              Navigator.pop(context);
                            });

                            Fluttertoast.showToast(
                              msg: "Delete!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              //timeInSecForIos: 1
                            );
                          },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                          // IconButton(onPressed: () {
                          //   setState(() {
                          //     edit = !edit;
                          //   });
                          // },
                          //   icon: Icon(
                          //     Icons.edit,
                          //     color: edit ? Colors.blue : Colors.white,
                          //     size: 28,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edit ? "Editing" : "View",
                          style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Your Expense",
                          style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
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

                        SizedBox(
                          height: 12,
                        ),
                        label("Amount"),
                        SizedBox(
                          height: 12,
                        ),
                        amount(),

                        SizedBox(
                          height: 12,
                        ),
                        label("Category"),
                        SizedBox(
                          height: 12,
                        ),
                        Wrap(
                          runSpacing: 10,
                          children: [
                            categorySelect("Personal",0xff234ebd),
                            SizedBox(
                              width: 10,
                            ),
                            categorySelect("Savings Tax Insurance",0xff234ebd),
                            SizedBox(
                              width: 10,
                            ),
                            categorySelect("Shopping",0xff234ebd),
                            SizedBox(
                              width: 10,
                            ),

                            categorySelect("Medical",0xff234ebd),
                            SizedBox(
                              width: 10,
                            ),

                            categorySelect("Grocery and Home utilities",0xff234ebd),
                            SizedBox(
                              width: 30,
                            ),
                            categorySelect("Others",0xff234ebd),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        edit ? button() : Container(),
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
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("expense" + phNum)
            .doc(widget.id)
            .update(
            {"title": _expenseController.text,
              "Category": category,
              "amount":int.parse(_amountController.text),
            });
        //Navigator.pop(context);
      },
      child: Container(
        height: 56,
        // width: MediaQuery
        //     .of(context)
        //     .size
        //     .width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xff8a32f1),
                Color(0xffad32f9),
              ],
            )
        ),
        child: Center(child: Text("UPDATE EXPENSE",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w600,

          ),
        ),
        ),
      ),
    );
  }


  Widget categorySelect(String label,int color) {
    return InkWell(
      onTap: edit
          ? () {
        setState(() {
          category = label;
        });
      }
          : null,
      child: Chip(
        backgroundColor: category==label? Colors.white :Color(color),

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            )
        ),
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 15,
          color: category == label ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,

        ),


        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }


  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _expenseController,
        enabled: edit,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Expense Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16.5,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget amount() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller:_amountController,
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
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

}


