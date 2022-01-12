
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plan_on/custom/CompletedTodoCard.dart';
import 'package:plan_on/pages/AddTodo.dart';
import 'package:plan_on/pages/view_completeddata.dart';

import '../sharedPref.dart';
import 'package:plan_on/pages/ExpenseHomePage.dart';

class CompletedTodo extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _CompletedTodoState();
}

class _CompletedTodoState extends State<CompletedTodo> {
  String phNum = SharedPref.getString("user_ph_no");
  Stream<QuerySnapshot>_stream;
  List<Select> selected=[];

  @override

  Widget build(BuildContext context) {
    _stream = FirebaseFirestore.instance.collection("TodoCompleted"+phNum).orderBy("date", descending: true).snapshots();
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "TODOs",
            style: TextStyle(
              fontSize: 34,
              color:Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // actions: [
          //   IconButton(onPressed: () {
          //
          //
          //   },
          //     icon: Icon(
          //       Icons.logout_sharp,
          //       color: Colors.white,
          //       size: 28,
          //     ),
          //   ),
          // ],
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

                      InkWell(
                        onTap: ()
                        {
                          Navigator.pop(context);

                        },
                        child: Container(
                          alignment: Alignment.center,
                          //color: Colors.blueGrey,
                          height: 35,
                          width: 170,



                          decoration:BoxDecoration(
                              shape: BoxShape.rectangle,

                          ),

                          child: Text("Pending Task",
                            style: TextStyle(

                              fontSize: 15,
                              color:Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,

                            ),

                          ),
                        ),
                      ),


                        Container(
                          alignment: Alignment.center,
                          //color: Colors.blueGrey,
                          height: 35,
                          width: 165,



                          decoration:BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.blue
                          ),

                          child: Text("Completed Task",
                            style: TextStyle(

                              fontSize: 15,
                              color:Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,



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
                // onTap: (){
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (builder)=>AuthenticatePage()));
               // },

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
                      MaterialPageRoute(builder: (builder)=>AddTodoPage()));
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
                    Text("Add ToDo",
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
                      MaterialPageRoute(builder: (builder)=>ExpenseHomePage()));
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
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder:(context,index){
                  IconData iconData;
                  Color iconColor;

                  Map<String,dynamic>document
                  =snapshot.data.docs[index].data() as Map<String,dynamic>;
                  switch(document["Category"]){
                    case "Important":
                      iconData=Icons.label_important;
                      iconColor=Colors.red;
                      break;
                    case "Planned":
                      iconData=Icons.lightbulb_outline_sharp;
                      iconColor=Colors.teal;
                      break;

                    default:
                      iconData=Icons.run_circle_outlined;
                      iconColor=Colors.red;

                  }
                  selected.add(


                    Select(
                        id:snapshot.data.docs[index].id,checkValue: false),
                  );
                  return InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder)=>ViewCompletedData(
                            document: document,
                            id:snapshot.data.docs[index].id,
                          )));
                    },
                    child: CompletedTodoCard(

                      title: document["title"]==null
                          ?"hey there"
                          :document["title"],
                      check: selected[index].checkValue,
                      iconBGColor: Colors.white,
                      iconColor: iconColor,
                      iconData: iconData,

                      index:index,
                      onChange: onChange,
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
    setState(() {
      selected[index].checkValue=!selected[index].checkValue;
    });


  }
}

class Select
{
  String id;
  bool checkValue=false;
  Select({this.id,this.checkValue});
}