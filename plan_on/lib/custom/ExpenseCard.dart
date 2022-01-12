// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class ExpenseCard extends StatelessWidget {
  const ExpenseCard(
      {Key key,

        this.title,
        this.iconData,
        this.iconColor,
        this.time,
        this.check,
        this.iconBGColor,
        this.onChange,
        this.index,
        this.amount,
        this.date,
      })
      : super(key: key);

  //dynamic allocation of value

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBGColor;
  final Function onChange;
  final int index;
  final int amount;
  final DateTime date;


  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(0xff2a2e3d),
        child: Column(

          children: <Widget>[


            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 33,
                    width: 36,
                    decoration: BoxDecoration(
                      color: iconBGColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      iconData,
                      color: iconColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),

                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color(0xff2a2e3d),
                        child: Text(
                          title,
                          style:TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                            color:Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),


                Expanded(
                  flex: 3, // 30% of space
                  child: Container(
                    color: Color(0xff2a2e3d),
                    child: Text(
                      '\₹$amount',
                      style:TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        color:Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ),

                ),


              ],
            ),


      Text(
        DateFormat.yMMMd().format(date),
        style:TextStyle(
          fontSize: 14,
          letterSpacing: 1,
          color:Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),

          ],
        ),

      ),


    );


  }


}