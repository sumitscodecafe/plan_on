import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../sharedPref.dart';

class ViewCompletedData extends StatefulWidget {
  ViewCompletedData({Key key, this.document, this.id}): super(key: key);
  final Map<String,dynamic>document;
  final String id;

  @override
  State<StatefulWidget> createState()=>_ViewCompletedDataState();
}



class _ViewCompletedDataState extends State<ViewCompletedData>{
  TextEditingController _titleController ;
  TextEditingController _descriptionController;
  String type;
  String category;
  bool edit = false;

  @override

  void initState(){
    super.initState();
    String title=widget.document["title"]==null
        ?"No Title"
        :widget.document["title"];
    _titleController=TextEditingController(text: title);
    _descriptionController=TextEditingController(text: widget.document["description"]);
    //type=widget.document["task"];
    category=widget.document["Category"];

  }

  int getId(){
    return int.parse(widget.id);
  }

  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color:Colors.white,
                          size: 28,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {
                            String phNum = SharedPref.getString("user_ph_no");
                            FirebaseFirestore.instance
                                .collection("TodoCompleted"+phNum)
                                .doc(widget.id)
                                .delete()
                                .then((value){
                              Navigator.pop(context);
                            });

                            Fluttertoast.showToast(
                              msg: "Removed!",
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
                          IconButton(onPressed: () {
                            setState(() {
                              edit=!edit;
                            });
                          },
                            icon: Icon(
                              Icons.edit,
                              color: edit?Colors.blue: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edit?"Editing":"View",
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
                        Text("Completed TODO",
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
                        label("Category"),
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
                        edit? button():Container(),
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
  Widget button(){
    return InkWell(
      onTap: (){
        String phNum = SharedPref.getString("user_ph_no");
        FirebaseFirestore.instance.collection("Todo"+phNum).doc(widget.id).update(
            {"title":_titleController.text,
              "task":type,
              "Category":category,
              "description":_descriptionController.text,
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
        child: Center(child: Text("UPDATE TASK",
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
        enabled: edit,
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
      onTap: edit
          ?(){
        setState(() {
          type=label;
        });

      }
          :null,
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
  Widget categorySelect(String label,int color){
    return InkWell(
      onTap: edit
          ?(){
        setState(() {
          category=label;
        });

      }
          :null,
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
        enabled: edit,
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


