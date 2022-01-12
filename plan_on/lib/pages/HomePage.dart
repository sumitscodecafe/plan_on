import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plan_on/custom/Auth_Service.dart';
import 'package:plan_on/custom/TodoCard.dart';
import 'package:plan_on/pages/AddTodo.dart';
import 'package:plan_on/pages/AuthenticatePage.dart';
import 'package:plan_on/pages/ExpenseHomePage.dart';
import 'package:plan_on/pages/completedTodo.dart';
import 'package:plan_on/pages/view_data.dart';

import '../sharedPref.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token;
  String logged_out_shpf;
  AuthClass authClass = AuthClass();
  //Widget currentPage = AuthenticatePage();

  @override
  void initState() {
    super.initState();
  }

  void checkLogin() async {
    token = await FirebaseAuth.instance.currentUser.getIdToken();
    SharedPref.getInstance();
    logged_out_shpf = SharedPref.getString("logged_out");
    String token_shpf = SharedPref.getString("token_shpf");

    token = await authClass.getToken();
    if(logged_out_shpf == "1")
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) => AuthenticatePage()), (
              route) => false);

    if (token == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => AuthenticatePage()),
              (route) => false);

      setState(() {
        if(Navigator.canPop(context))
          Navigator.pop(context);
        else
          SystemNavigator.pop();
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>AuthenticatePage()));
        // Navigator.of(context).pushNamedAndRemoveUntil('/AuthenticatePage', (route) => false);
        // currentPage = HomePage();
      });
    } else {
      SharedPref.putString("logged_out", "0");
      SharedPref.putString("token_shpf", token);
    }
  }

  @override

  String doc_title, doc_type, doc_cat, doc_desc, doc_id, doc_date;
  String phNum = SharedPref.getString("user_ph_no");

  Stream<QuerySnapshot> _stream;
  List<Select> selected=[];

  Widget build(BuildContext context) {

    //checkLogin();

    _stream = FirebaseFirestore.instance.collection("Todo"+phNum).orderBy("date", descending: true).snapshots();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "TODO",
            style: TextStyle(
              fontSize: 34,
              color:Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Expanded(
                    child: AlertDialog(

                      title: Text('Warning!'),
                      content: Text('Are you sure?'),
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
                            _signOut();
                            Fluttertoast.showToast(
                              msg: "Logged Out",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              //timeInSecForIos: 1
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text('LOGOUT'),
                        ),
                      ],
                    ),

                  );
                },
              );

            },
              icon: Icon(
                Icons.logout_sharp,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
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

                      child: Text("Pending Task",
                        style: TextStyle(

                          fontSize: 15,
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,

                        ),

                      ),
                    ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>CompletedTodo()));

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
                      child: Text("Completed Task",
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
                onTap: (){ },

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
                doc_date = document["date"].toString();
                doc_id = snapshot.data.docs[index].id;

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
                  Select(id:snapshot.data.docs[index].id, checkValue: false),
                );
                return InkWell(

                  onTap: (){
                    Navigator.push(context,
                          MaterialPageRoute(builder: (builder)=>ViewData(
                            document: document,
                            id:snapshot.data.docs[index].id,
                          )));
                  },
                  child: TodoCard(
                    title: document["title"]==null
                            ?"hey there"
                            :document["title"],
                    check: false,
                    iconBGColor: Colors.white,
                    iconColor: iconColor,
                    iconData: iconData,

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

  Future<void> _signOut() async{
    // SharedPref.getInstance();
    SharedPref.putString("logged_out", "1");
    //TODO: clear string shpf here
   //SharedPref.clrString();
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AuthenticatePage()), (route) => false);

  }

  void onChange(index)
  {
    setState(() {
      selected[index].checkValue=!selected[index].checkValue;
      //DateTime date = DateTime.now();
      //Send to completed list
      String phNum = SharedPref.getString("user_ph_no");
      FirebaseFirestore.instance.collection("TodoCompleted"+phNum).add(
          {"title": doc_title,
            //"task": doc_type,
            "Category": doc_cat,
            "description": doc_desc,
            "date": doc_date,
          });
     //Navigator.pop(context);

      Fluttertoast.showToast(
            msg: "Task Completed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            //timeInSecForIos: 1
          );

      //Delete
      FirebaseFirestore.instance
          .collection("Todo"+phNum)
          .doc(doc_id)
          .delete()
          .then((value){
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (builder)=>HomePage()));
      });

      // Fluttertoast.showToast(
      //   msg: "Deleted",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   //timeInSecForIos: 1
      // );

    });


  }
}

class Select
{
  String id;
  bool checkValue=false;
  Select({this.id,this.checkValue});
}