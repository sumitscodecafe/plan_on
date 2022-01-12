import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../sharedPref.dart';

class AddTodoPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState()=>_AddTodoPageState();

}

class _AddTodoPageState extends State<AddTodoPage>{
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  //String type ="";
  String category ="";
  String phNum = SharedPref.getString("user_ph_no");

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
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
      Text("New TODO",
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
      label("Task Title"),
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
      // SizedBox(
      //   height: 25,
      // ),
      label("Description"),
      SizedBox(
        height: 12,
      ),
      description(),
      SizedBox(
        height: 30,
      ),
      label("Task Type"),
      SizedBox(
        height: 12,
      ),
      Wrap(
        runSpacing: 10,
        children: [
          categorySelect("Important",0xff2664fa),
          SizedBox(
            width: 20,
          ),
          categorySelect("Planned",0xff2664fa),
          SizedBox(
            width: 20,
          ),
          // categorySelect("Work",0xff6557ff),
          // SizedBox(
          //   width: 20,
          // ),
          // categorySelect("Design",0xff234ebd),
          // SizedBox(
          //   width: 20,
          // ),
          // categorySelect("Run",0xff2bc8d9),

        ],
      ),
      SizedBox(
        height: 50,
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
  Widget button(){
    return InkWell(
      onTap: (){
        DateTime date = DateTime.now();
        FirebaseFirestore.instance.collection("Todo"+phNum).add(
        {"title":_titleController.text,

          "Category":category,
          "description":_descriptionController.text,
          "date": date,
        });
        Navigator.pop(context);

      },
      child: Container(
        height: 56,
          width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent,
        ),
        child: Center(child: Text("ADD TASK",
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

  Widget description(){
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Add"
                " Description",
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
          //type=label;
        });

      },
      child: Chip(
        backgroundColor:Color(color),


        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            )
        ),

        label: Text(label),
          labelStyle: TextStyle(
          fontSize: 15,
          color:Colors.white,
            fontWeight: FontWeight.w600,

      ),



      labelPadding: EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 3.8,
      ),
      ),
    );
  }
  Widget categorySelect(String label,int color){
    return InkWell(
      onTap: (){
        setState(() {
          category=label;
        });

      },
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
        controller: _titleController,
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


