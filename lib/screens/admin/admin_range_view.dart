import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:myams/models/user.dart'as model;
import 'package:myams/screens/admin/student_view_attendance.dart';

import '../../constants.dart';

class AdminRangeView extends StatefulWidget {
  const AdminRangeView({Key? key}) : super(key: key);

  @override
  State<AdminRangeView> createState() => _AdminRangeViewState();
}

class _AdminRangeViewState extends State<AdminRangeView> {
  TextEditingController editingControllerFrom=TextEditingController();
  TextEditingController editingControllerTo=TextEditingController();
  bool show=false;
  late List values=List.empty(growable: true);

  var date1,date2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    values.clear();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        show=true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: editingControllerFrom,
              decoration: InputDecoration(
                suffix: IconButton(
                    onPressed: (){
                      _showDatePicker(context,1);
                      }, icon: const Icon(Icons.date_range)
                ),
                border: const OutlineInputBorder(),
                hintText: 'From Date  8-7-2022',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: editingControllerTo,
              decoration: InputDecoration(
                suffix: IconButton(
                    onPressed: (){_showDatePicker(context,2);}, icon: const Icon(Icons.date_range)
                ),
                border: const OutlineInputBorder(),
                hintText: 'To Date 8-7-2022',
              ),
            ),
            ElevatedButton(onPressed: (){
              // search(editingControllerFrom.text,editingControllerTo.text);
              search();

            }, child: const Text("Search")),
          ],
        ),
      ),
    );
  }
  void search()
  {
    // editingControllerFrom.text='11-7-2022';
    // editingControllerTo.text='12-7-2022';
    // date1= 2022-07-11;
    // date2= 2022-07-12;
    // if(date1!.isBefore(date2))
      {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>StViewAttendance(date1: editingControllerFrom.text.toString(),date2: editingControllerTo.text.toString(),)
        ));
      }
  }
  // void fillList(DocumentSnapshot snapshot)
  // {
  //   var allVal=snapshot.reference.collection('info').doc().get();
  //   allVal.then((value) =>
  //       values.add(model.Student.getValuesFromSnap(value))
  //   );
  // }

  void _showDatePicker(BuildContext context, var x) {
    showCrDatePicker(
      context,
      properties: DatePickerProperties(
        firstWeekDay: WeekDay.monday,
        pickerMode: TouchMode.singleTap,
        okButtonBuilder: (onPress) =>
            ElevatedButton(child: const Text('OK'), onPressed: (){
              onPress!.call();
              print("ok Pressed");
            }),
        cancelButtonBuilder: (onPress) =>
            OutlinedButton(child: const Text('CANCEL'),onPressed: (){
              onPress!.call();
              // Navigator.pop(context);
            }),
        initialPickerDate: DateTime.now(),
        onDateRangeSelected: (DateTime? rangeBegin, DateTime? rangeEnd) {
          var formattedDate = "${rangeBegin!.day}-${rangeBegin!.month}-${rangeBegin!.year}";
          if(x==1)
            {
              editingControllerFrom.text=formattedDate;
              date1=rangeBegin;
              print(date1);
            }
          else
            {
              editingControllerTo.text=formattedDate;
              date2=rangeBegin;
            }
        },
      ),
    );
  }
}
