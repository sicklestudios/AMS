import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  String? grade;
  String? total;
  String? presents;
  String? absents;
  String? leaves;

  User(
  {
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.grade,
    this.total,
    this.presents,
    this.absents,
    this.leaves,
  });
  Map<String,dynamic> toJson()=> {
    'uid':uid,
    'name':name,
    'email':email,
    'photoUrl':photoUrl,
    'grade':grade,
    'total':total,
    'presents':presents,
    'absents':absents,
    'leaves':leaves,
  };
  static User getValuesFromSnap(DocumentSnapshot snapshot)
  {
    var snap=snapshot.data() as Map<String,dynamic>;
    return User(
      uid: snap['uid'],
      name: snap['name'],
      email: snap['email'],
      photoUrl: snap['photoUrl'],
      grade: snap['grade'],
      total: snap['total'],
      presents: snap['presents'],
      absents: snap['absents'],
      leaves: snap['leaves'],
    );
  }
}
class Student{
  final String uid;
  final String name;
  int  attendance;
  final String photoUrl;
  final String date;

  Student(
      {
        required this.uid,
        required this.name,
        required this.attendance,
        required this.photoUrl,
        required this.date,
      });
  Map<String,dynamic> toJson()=> {
    'uid':uid,
    'name':name,
    'attendance':attendance,
    'photoUrl':photoUrl,
    'date':date,
  };
  static Student getValuesFromSnap(DocumentSnapshot snapshot)
  {
    var snap=snapshot.data() as Map<String,dynamic>;
    return Student(
      uid: snap['uid'],
      name: snap['name'],
      attendance: snap['attendance'],
      photoUrl: snap['photoUrl'],
      date: snap['date'],
    );
  }
}
class Attendance {
  final String uid;
  final String total;
  final String totalPresents;
  final String totalAbsents;
  final String totalLeaves;

  Attendance({
    required this.uid,
    required this.total,
    required this.totalPresents,
    required this.totalAbsents,
    required this.totalLeaves,
  });

  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'total': total,
        'totalPresents': totalPresents,
        'totalAbsents': totalAbsents,
        'totalLeaves': totalLeaves,
      };

  static Attendance getValuesFromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Attendance(
      uid: snap['uid'],
      total: snap['total'],
      totalPresents: snap['totalPresents'],
      totalAbsents: snap['totalAbsents'],
      totalLeaves: snap['totalLeaves'],
    );
  }
}
