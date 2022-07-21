import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myams/models/user.dart'as model;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:grouped_list/grouped_list.dart';


import '../../constants.dart';
import '../../methods/attendance_methods.dart';
import '../../methods/global_methods.dart';
import '../auth/image_bio.dart';
class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);
  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  late model.User _userInfo;
  bool loaded=false;
  //For getting the current users information
  Future getValues()async{
    var values= await FirebaseFirestore.instance.collection('users').doc(firebaseAuth.currentUser?.uid).get();
    _userInfo=model.User.getValuesFromSnap(values);
    setImageData(_userInfo.photoUrl);
    return values;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData(context);
  }
  @override
  Widget build(BuildContext context) {
    getValues().then((value) =>
        setState(() {
          _userInfo=model.User.getValuesFromSnap(value!);
          setImageData(_userInfo.photoUrl);
          loaded=true;
        })
    );
    return loaded?Scaffold(
      appBar: AppBar(
        title: const Text(
            'Home'
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BioImage(fromSignup: false,img:_userInfo.photoUrl,)),
                );
              },
              icon: const Icon(Icons.menu_sharp)
          )
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            _StudentCard(
              user: _userInfo,
            ),
          ],
        ),
      ) ,
    ):Container(color: Colors.white,child: const Center(child: CircularProgressIndicator(),));
  }
}

class _StudentCard extends StatefulWidget {
  final model.User user;
  const _StudentCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_StudentCard> createState() => _StudentCardState();
}
class _StudentCardState extends State<_StudentCard> {
  bool isExpanded=false;
  late TooltipBehavior _tooltipBehavior;
  int count=0;
  late Key updateKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltipBehavior =  TooltipBehavior(enable: true);
    updateKey=ValueKey(count.toString());
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child:Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(widget.user.name,style: const TextStyle(fontSize: 30),),
                          const SizedBox(height: 20,),
                          const Text("Attendance",style: TextStyle(fontSize: 20),),
                        ],
                      ),
                      CircleAvatar(
                        backgroundImage: imageData ?? const CircularProgressIndicator(),
                        radius: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  _Buttons(user:widget.user),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,top: 20.0,),
                    child: Text("Today's Date: ${getDate()}"),
                  ),
                  ExpansionPanelList(
                    elevation: 0,
                    animationDuration: const Duration(milliseconds: 1000),
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, expanded) {
                          return const ListTile(
                            title: Text('', style: TextStyle(color: Colors.black),),
                          );
                        },
                        body:Column(
                          children: [
                            SfCircularChart(
                                title: ChartTitle(
                                    text: 'Total Classes: ${int.parse(widget.user.total!)}',
                                    backgroundColor: Colors.white24,
                                    // Aligns the chart title to left
                                    alignment: ChartAlignment.center,
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                    )
                                ),
                                annotations: <CircularChartAnnotation>[
                                  CircularChartAnnotation(
                                      widget: PhysicalModel(
                                          shape: BoxShape.circle,
                                          elevation: 10,
                                          shadowColor: Colors.black,
                                          color: const Color.fromRGBO(230, 230, 230, 1),
                                          child: Container())),
                                  CircularChartAnnotation(
                                      widget: Text('${double.parse(((int.parse(widget.user.presents!)/(int.parse(widget.user.total!)))).toStringAsFixed(2))*100}%',
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 25)))
                                ],
                                tooltipBehavior: _tooltipBehavior,
                                legend: Legend(isVisible: true),
                                series: <CircularSeries>[
                              // Render pie chart
                              DoughnutSeries<ChartData, String>(
                                  dataSource: [
                                    ChartData('Presents', int.parse(widget.user.presents!),Colors.green),
                                    ChartData('Absents', int.parse(widget.user.absents!),Colors.red),
                                    ChartData('Leaves', int.parse(widget.user.leaves!),Colors.blue)],
                                  pointColorMapper:(ChartData data,  _) => data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  radius:'100%',
                                  innerRadius: '65%',
                                  dataLabelSettings:const DataLabelSettings(isVisible : true),
                              )
                            ]),
                            Text("Your Grade is: ${widget.user.grade}",style: const TextStyle(fontSize: 20))
                          ],
                        ),
                        isExpanded: isExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                    dividerColor: Colors.grey,
                    expansionCallback: (panelIndex, expanded) {
                      isExpanded = !isExpanded;
                      setState(() {

                      });
                    },
                  ),
                  // const GFAccordion(
                  //     content: 'GetWidget is an open source library that comes with pre-build 1000+ UI components.',
                  //     collapsedIcon: Text('More'),
                  //     expandedIcon: Text('Hide')
                  // ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text("Your Attendance Detail",style: TextStyle(fontSize: 18),),
          ),
          _ListStudentAttendance(
            callback:(){ count++;
            updateKey=ValueKey(count.toString());
          },key: updateKey,)
        ],
      ),
    );
  }
}

class _Buttons extends StatefulWidget {
  final model.User user;
  const _Buttons({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_Buttons> createState() => _ButtonsState();
}
class _ButtonsState extends State<_Buttons> {
  bool shouldInform=false;
  String markAttendanceString='Attendance marked';
  String markLeave='Leave Unavailable';

  Future getAttendance()async
  {
    return await firebaseFirestore.collection('attendance').doc(getDate()).collection('info').doc(firebaseAuth.currentUser?.uid).get();
  }
  @override
  Widget build(BuildContext context) {
    getAttendance().then((value) =>
        setState(() {
          int val=model.Student.getValuesFromSnap(value!).attendance;
          if(val==2)
          {
            markLeave='Leave Allotted';
            markAttendanceString=markLeave;
          }
          else if(val!=0 && val!=10)
          {
            markAttendanceString="Mark Attendance";
            if(int.parse(widget.user.leaves!)<=6)
              {
                shouldInform=false;
                markLeave='Mark Leave';
              }
            else
              {
                shouldInform=true;
                markLeave='Not Applicable';
              }
          }
          else if (val==10)
          {
            markLeave='Leave Requested';
            markAttendanceString="Leave Requested";
          }

        })
    );
    return Column(
      children: [
        Row(
          children: [
            markAttendanceString=='Mark Attendance'&&markLeave!='Leave Requested'?ElevatedButton(
              onPressed: (){
                markAttendance(widget.user,"0");
                setState(() {
                  markAttendanceString='Attendance marked';;
                  markLeave='Leave Unavailable';
                });
              },
              child: Text(markAttendanceString,softWrap: true,),
            ):ElevatedButton(
              onPressed: null,
              child: Text(markAttendanceString),
            ),
            const SizedBox(width: 20,),
            markLeave=='Mark Leave'&&markAttendanceString!="Attendance marked"?ElevatedButton(
              onPressed: (){
                requestLeave(widget.user);
                setState(() {
                  markLeave="Leave Requested";
                  markAttendanceString="Leave Requested";
                });
              },
              child: Text(markLeave,softWrap: true,),
            ):ElevatedButton(
              onPressed: null,
              child: Text(markLeave),
            ),
          ],
        ),
        shouldInform?const Text('You have reached your leaves limit',style: TextStyle(fontSize: 18),):Container()
      ],
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
  int i=0;
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
            return show? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          allValues.clear();
                          i=0;
                          widget.callback;
                        });
                      },
                      child: const Text('Refresh')),
                ),
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
                  itemComparator: (item1, item2) => item1['date'].compareTo(item2['date']), // optional
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: true, // optional
                  order: GroupedListOrder.DESC, // optional
                ),
              ],
            ): const Center(
                child: CircularProgressIndicator()
          );

            // ListView.separated(
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     separatorBuilder: (context, index) {
            //       return const Divider();
            //     },
            //     itemCount: allValues.length,
            //     itemBuilder: (context, index) {
            //       return showWidget(allValues[index]);
            //     }):const Center(
            //   child: Center(child: CircularProgressIndicator()),
            // );
          } else {
            print("No data found");
            return const Text("No data");
          }
        }
    );
  }
  void fillList(DocumentSnapshot snapshot) async
  {
      var values=snapshot.reference.collection('info').doc(firebaseAuth.currentUser!.uid).get();
      values.then((value) =>
          allValues.add(model.Student.getValuesFromSnap(value))
      );
  }
  showWidget(var val)
  {
    model.Student student= val;
    return InkWell(
        onTap: (){
        },
        child: layoutHomeScreenStudents(student)
      // child: Text('')
    );
  }
}


