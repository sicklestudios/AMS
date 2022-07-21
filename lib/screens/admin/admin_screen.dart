// import 'package:ams/constant_files/utils.dart';
// import 'package:ams/screens/admin_edit_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ams/screens/logout.dart';
// import 'package:flutter/material.dart';
// import 'package:ams/models/user.dart'as model;
// class AdminScreen extends StatefulWidget {
//   const AdminScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AdminScreen> createState() => _AdminScreenState();
// }
//
// class _AdminScreenState extends State<AdminScreen> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // setStudentsAttendance();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//               'Admin Screen'
//           ),
//           actions: [
//             IconButton(
//                 onPressed: (){
//                   Navigator.push(context,
//                     MaterialPageRoute(builder: (context) =>LogOut()),
//                   );
//                 },
//                 icon: Icon(Icons.menu_sharp)
//             )
//           ],
//         ),
//       body: studentsScreen()
//       ,
//     );
//   }
// }
// studentsScreen()
// {
//   return FutureBuilder(
//     // stream:  FirebaseFirestore.instance.collection('chats').doc('messages').collection('uid1').snapshots(),
//       future:  FirebaseFirestore.instance.collection("attendance").doc("3-7-2022").collection("info").get(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           // print(snapshot.hasData);
//           // print('Snapshot has data  ' + snapshot.data!.docs[1].id.toString());
//         // .doc("2-7-2022").collection("info")
//         //   DocumentSnapshot doc = await snapshot.data!.docs[0].reference.collection('info').doc(FirebaseAuth.instance.currentUser!.uid).get();
//           return ListView.separated(
//               separatorBuilder: (context, index) {
//                 return Divider();
//               },
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 // print(snapshot.data!.docs[index].id);
//                 // print(snapshot.data!.docs.length);
//                 DocumentSnapshot doc = snapshot.data!.docs[index];
//                 // doc.reference.collection('info').;
//                 // print(doc.id);
//                 // if(doc.id.contains('uid1'))
//                 //   {
//                 //     print('itContains');
//                 //     Future docSnap=doc.reference.collection('allMessages').doc('info').get();
//                 //     docSnap.whenComplete(() => {
//                 //       doc=docSnap as DocumentSnapshot<Object?>
//                 //     });
//                 model.Student student=model.Student.getValuesFromSnap(doc);
//                 return InkWell(
//                     onTap: (){
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context)=>EditScreen(student:student)
//                       ));
//                     },
//                     child: layoutHomeScreenStudents(student)
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
