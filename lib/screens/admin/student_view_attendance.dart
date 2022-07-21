import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myams/models/user.dart'as model;

import '../../constants.dart';
import '../auth/admin_edit_screen.dart';

class StViewAttendance extends StatefulWidget {
  model.User? st;
  String? date1;
  String? date2;
  StViewAttendance({
    Key? key,
    this.st,
    this.date1,
    this.date2
  }) : super(key: key);

  @override
  State<StViewAttendance> createState() => _StViewAttendanceState();
}
class _StViewAttendanceState extends State<StViewAttendance> {
  List allValues=List.empty(growable: true);
  bool show=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allValues.clear();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        show=true;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:const Text(
            'View Attendance'
        ),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () {
          Navigator.of(context).pop();
        },),
      ),
      body:StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore.collection('attendance').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for(int i=0;i<snapshot.data!.docs.length;i++)
                {
                  DocumentSnapshot doc = snapshot.data!.docs[i];
                  fillList(doc);
                }
              allValues.reversed;
              return show? SingleChildScrollView(
                child: Column(
                  children: [
                    GroupedListView<dynamic, String>(
                      shrinkWrap: true,
                      elements: allValues,
                      physics: NeverScrollableScrollPhysics(),
                      cacheExtent: 0,
                      groupBy: (element){
                        return element.date;
                      },
                      groupSeparatorBuilder: (String groupByValue){
                        return Center(
                          child: Container(
                            width: 100,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            height: 40,
                            child: Center(
                              child: Text(
                                groupByValue,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context, dynamic element)
                      {
                        return showWidget(element);
                      },
                      // itemComparator: (item1, item2) => item1['date'].compareTo(item2['date']), // optional
                      useStickyGroupSeparators: true, // optional
                      floatingHeader: true, // optional
                      order: GroupedListOrder.DESC, // optional
                    ),
                  ],
                ),
              ): const Center(
                  child: CircularProgressIndicator()
              );
                    // return InkWell(
                    //     onTap: (){
                    //       // Navigator.of(context).push(MaterialPageRoute(
                    //       //     builder: (context)=>EditScreen(student:student)
                    //       // ));
                    //     },
                    //     child: layoutHomeScreenStudents(student!)
                    //     // child: Text('')
                    // );
                    // }
                    // else
                    //   {
                    //     print("No chats");
                    //     return const Text("No Chats");
                    //   }

                  // });
            } else {
              print("No data found");
              return const Text("No data");
            }
          }
      )
    );

  }
  //Dont know (if part works or not)
  void fillList(DocumentSnapshot snapshot) async
  {
    if(widget.date1!=null)
      {
        var values=await snapshot.reference.collection('info').get();
        values.docs.forEach((element) {
          DocumentSnapshot snapshots=element;
          String tempDate=model.Student.getValuesFromSnap(snapshots).date;
          if(checkDates(tempDate, widget.date1!,true)&&checkDates(tempDate, widget.date2!,false))
            {
              allValues.add(model.Student.getValuesFromSnap(snapshots));
            }
        });
      }
    else
      {
        var values=snapshot.reference.collection('info').doc(widget.st!.uid).get();
        values.then((value) =>
            allValues.add(model.Student.getValuesFromSnap(value))
        );
      }
  }
  bool checkDates(String va1,String va2, bool greater )
  {
    int day1=int.parse((va1.substring(0,va1.indexOf('-'))));
    int day2=int.parse(va2.substring(0,va2.indexOf('-')));

    int month1=int.parse(va1.substring(va1.indexOf('-')+1,va1.lastIndexOf('-')));
    int month2=int.parse(va2.substring(va2.indexOf('-')+1,va2.lastIndexOf('-')));

    int year1=int.parse(va1.substring(va1.lastIndexOf('-')+1,va1.length));
    int year2=int.parse(va2.substring(va2.lastIndexOf('-')+1,va2.length));

    if(greater)
      {
        if(day1>=day2)
        {
          if(month1>=month2) {
            if(year1>=year2) {
              return true;
            }
          }
        }
      }
    else
      {
        if(day1<=day2)
        {
          if(month1<=month2) {
            if(year1<=year2) {
              return true;
            }
          }
        }
      }
    return false;
  }

  showWidget(var val)
  {
    model.Student student= val;
    return InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=>EditScreen(student:student)
          ));
        },
        child: layoutHomeScreenStudents(student)
      // child: Text('')
    );
  }

}
