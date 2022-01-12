import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp>_initialization=Firebase.initializeApp();

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future:_initialization,
      builder: (context,snapshot) {
        //check for error
        if(snapshot.hasError){
          print("Something went Wrong");
        }
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'PlanOn',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomeScreen(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }



}