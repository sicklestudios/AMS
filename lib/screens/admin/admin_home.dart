import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:myams/models/user.dart'as model;
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../methods/attendance_methods.dart';
import '../../methods/auth_methods.dart';
import '../../methods/global_methods.dart';
import '../../providers/user_provider.dart';
import '../auth/admin_edit_screen.dart';
import 'admin_range_view.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  double _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData(context);
    pageController.addListener(() {
      setState(() {
        _page = pageController.page!;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Admin Home'
          ),
          actions: [
            IconButton(
                onPressed: (){
                  AuthMethods().signOut();
                  // Navigator.pop(context);
                },
                icon: Icon(Icons.logout)
            )
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          animationDuration: const Duration(milliseconds: 300),
          key: _bottomNavigationKey,
          items: const <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.bookmark_add_sharp, size: 30),
            Icon(Icons.date_range, size: 30),
          ],
          index: _page.toInt(),
          onTap: (index) {
            setState(() {
              pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
              _page = index.toDouble();
            });
          },
        ),
        body:PageView(
          controller: pageController,
          children: <Widget>[
            // Add children
            _ListStudentAttendance(
                callback: (){}
            ),
            adminMarkAllAbsent(),
            AdminRangeView(),
            // contactsWidget(),
            // callsWidget()
          ],
        )
    );
  }
}
class _ListStudentAttendance extends StatefulWidget {
  VoidCallback callback;
  _ListStudentAttendance({
    Key? key,
    required this.callback
  }) : super(key: key);

  @override
  State<_ListStudentAttendance> createState() => _ListStudentAttendanceState();
}
class _ListStudentAttendanceState extends State<_ListStudentAttendance> {
  List allValues=List.empty(growable: true);
  bool show=false;
  int i=0;
  _onLayoutDone(_) {
    allValues.clear();
    i=0;
    //do your stuff
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(_onLayoutDone);
    allValues.clear();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        show=true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firebaseFirestore.collection('attendance').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for(i;i<snapshot.data!.docs.length;i++)
            {
              DocumentSnapshot doc = snapshot.data!.docs[i];
              fillList(doc);
            }
            return show?  SingleChildScrollView(
              child: Column(
                children: [
                  GroupedListView<dynamic, String>(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    elements: allValues,
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
          } else {
            print("No data found");
            return Center(child: const Text("No data"));
          }
        }
    );
  }
  void fillList(DocumentSnapshot snapshot) async
  {
    var values=snapshot.reference.collection('info').get();
    values.then((value) => {
      for(int i=0;i<value.docs.length;i++)
      {
        allValues.add(model.Student.getValuesFromSnap(value.docs[i]))
      }
    });
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
// decideShowDate(formattedDate,student, showedDate)
// {
//   if(formattedDate!=student.date) {
//     formattedDate=student.date;
//     showedDate=false;
//   }
//   if(showedDate==false)
//   {
//     showedDate=true;
//     return Container(
//       child: Text(student.date),
//     );
//   }
//   return Container();
// }
adminMarkAllAbsent()
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Mark All the students as absent initially"),
      Center(
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    setStudentsAttendanceAdmin();
                  },
                  child: const Text('Mark Absent'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}





//adminHomeWidget()
// {
//   bool showedDate=false;
//   return FutureBuilder(
//       future:  FirebaseFirestore.instance.collection("attendance").doc(formattedDate).collection("info").get(),
//       // future:  FirebaseFirestore.instance.collection("attendance").get(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//
//           return ListView.separated(
//               separatorBuilder: (context, index) {
//                 return Divider();
//               },
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 // print(snapshot.data!.docs[index].id);
//                 // print(snapshot.data!.docs.length);
//                 DocumentSnapshot doc = snapshot.data!.docs[index];
//                 // var values=doc.reference.collection('info').get();
//                 // print(doc.id);
//                 // if(doc.id.contains('uid1'))
//                 //   {
//                 //     print('itContains');
//                 //     Future docSnap=doc.reference.collection('allMessages').doc('info').get();
//                 //     docSnap.whenComplete(() => {
//                 //       doc=docSnap as DocumentSnapshot<Object?>
//                 //     });
//                 // DocumentSnapshot documentSnapshot=values
//                 model.Student student=model.Student.getValuesFromSnap(doc);
//
//                 return Center(
//                   child: Column(
//                     children: [
//                       // decideShowDate(formattedDate, student,showedDate),
//                       InkWell(
//                           onTap: (){
//                             // Navigator.of(context).push(MaterialPageRoute(
//                             //     builder: (context)=>EditScreen(student:student)
//                             // ));
//                           },
//                           child: layoutHomeScreenStudents(student)
//                       ),
//                     ],
//                   ),
//                 );
//                 // }
//                 // else
//                 //   {
//                 //     print("No chats");
//                 //     return const Text("No Chats");
//                 //   }
//
//               });
//         } else {
//           print("No data found");
//           return Text("No data");
//         }
//       }
//   );
// }