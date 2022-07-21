import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

var firebaseAuth=FirebaseAuth.instance;
var firebaseFirestore=FirebaseFirestore.instance;

var imageData;
setImageData(String url)
{
  imageData=NetworkImage(url);
}


//Information
//present=0
//absent=1
//leaveAllotted=2
//leaveRequested=10

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final int  y;
  final Color? color;
}

void showFloatingFlushBar(BuildContext context, String upMessage, String downMessage) {
  Flushbar(
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 1),
    backgroundGradient: LinearGradient(
      colors: [Colors.blue.shade800, Colors.blueAccent.shade700],
      stops: [0.6, 1],
    ),
    boxShadows: const [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: upMessage,
    message: downMessage,
  ).show(context);
}
Widget layoutHomeScreenStudents(Student student)
{
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: imageData ?? NetworkImage(student.photoUrl),
              radius: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,5),
                    child: Text(
                      student.name,
                      style: const TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,2,0,5),
                    child: Text(
                      student.date,
                      style: const TextStyle(
                          fontSize: 15
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 125,
          decoration: BoxDecoration(
              color: _decideColor(student.attendance),
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          height: 30,
          child: Center(
            child: Text(
              _decideText(student.attendance),
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white
              ),
            ),
          ),
        ),
      )
    ],
  );
}
_decideText(int val)
{
  if(val==10)
    {
      return "Leave Requested";
    }
  else if(val==0)
    {
      return "Present";
    }
  else if(val==1)
    {
      return "Absent";
    }
  else
    {
      return 'On Leave';
    }
}
_decideColor(int val)
{
  if(val==10)
  {
    return Colors.blueAccent;
  }
  else if(val==0)
  {
    return Colors.green;
  }
  else if(val==2)
  {
    return Colors.blue;
  }
  else
  {
    return Colors.red;
  }
}