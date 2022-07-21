import 'package:myams/methods/attendance_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/user.dart';

class EditScreen extends StatefulWidget {
  Student student;

  EditScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late Student st;
  Color buttonColorActive=Colors.blueAccent;
  // Color buttonColorInActive=Colors.transparent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    st = widget.student;
    showGradesETC();
  }

  String? present='';
  String? absent='';
  String? leaves='';
  String? grade='';
  showGradesETC()
  {
    User user;
    String uid=widget.student.uid;
    var values=firebaseFirestore.collection('users').doc(uid).get();
    values.then((value) => {
        setState(() {
          DocumentSnapshot documentSnapshot=value;
          user=User.getValuesFromSnap(documentSnapshot);
            grade=user.grade;
            present=user.presents;
            leaves=user.leaves;
            absent=user.absents;
        })
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Date: " + st.date,
              style: const TextStyle(fontSize: 34),
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(st.photoUrl),
            ),
            const SizedBox(height: 10,),
            Text.rich(
              TextSpan(
                // with no TextStyle it will have default text style
                style: const TextStyle(fontSize: 22),
                text: 'Student Name: ',
                children: <TextSpan>[
                  TextSpan(text: st.name, style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 22),
                text: 'Attendance: ',
                children: <TextSpan>[
                  TextSpan(text: _decideText(st.attendance), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(color:Colors.green),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          attendance('0',st);
                        },
                        child: const Text('Present'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.blueAccent),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          attendance('2',st);
                        },
                        child: Text(st.attendance==10?'Grant Leave':'Leave'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(color:Colors.red),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          attendance('1',st);
                        },
                        child: const Text('Absent'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 30,),
                Text("Total Presents: ${present!}",style: const TextStyle(fontSize: 25),),
                const SizedBox(height: 10,),
                Text("Total Absents: ${absent!}",style: const TextStyle(fontSize: 25),),
                const SizedBox(height: 10,),
                Text("Total Leaves: ${leaves!}",style: const TextStyle(fontSize: 25),),
                const SizedBox(height: 10,),
                Text("Grade : ${grade!}",style: const TextStyle(fontSize: 25),),
              ],
            )
          ],
        ),
      ),
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

  
}
