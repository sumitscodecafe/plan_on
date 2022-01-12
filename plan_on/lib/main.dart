import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plan_on/pages/AuthenticatePage.dart';
import 'package:plan_on/sharedPref.dart';

import './pages/AddTodo.dart';
import './pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Widget currentPage = AuthenticatePage();
    SharedPref.getInstance();
    String logged_out_shpf = SharedPref.getString("logged_out");
    String logged_in_flag = SharedPref.getString("logged_in_flag");
    if(logged_in_flag == "1")
      currentPage = HomePage();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage()), (route) => false);

    //Verify existing user
    //SharedPref.getInstance();
    // String logged_in_flag = SharedPref.getString("logged_in_flag");
    // if(logged_in_flag == "1")
    //   currentPage = HomePage();
    // else
    //   currentPage = AuthenticatePage();

    return MaterialApp(
      title: 'PlanOn',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          // errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
      home: currentPage,
      debugShowCheckedModeBanner: false,
    );
  }
}


