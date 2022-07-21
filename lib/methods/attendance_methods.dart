import 'package:myams/constants.dart';
import 'package:myams/models/user.dart'as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'global_methods.dart';

void markAttendance(model.User user,String val)
{
  Map<String,dynamic> toJson()=>
      {
        'x': '',
      };
  model.Student student=model.Student(uid: user.uid, name: user.name, attendance: int.parse(val), photoUrl: user.photoUrl,date: getDate());
  firebaseFirestore.collection('attendance').doc(getDate()).collection('info').doc(user.uid).set(student.toJson()).whenComplete(() =>print("done"));
  if(val!='10')
    {
      setGrade(user);
      setOtherInfo(val, user);
    }
  firebaseFirestore.collection('attendance').doc(getDate()).set(toJson());
}
void setGrade(user)
{
  String grade='A';
  if(int.parse(user.presents)>=20&&int.parse(user.presents)<26) {
    grade = 'B';
  }
  else if(int.parse(user.presents)>=15&&int.parse(user.presents)<20) {
    grade='C';
  }
  else {
    grade='D';
  }
  firebaseFirestore.collection('users').doc(user.uid).update({
    'grade':grade,
  });
}
void setOtherInfo(val,user)
{
  if(val=='0')
  {
    firebaseFirestore.collection('users').doc(user.uid).update({
      'presents':(int.parse(user.presents)+1).toString(),
      'absents':(int.parse(user.absents)-1).toString()

    });
  }
  else if(val=='1')
  {
    firebaseFirestore.collection('users').doc(user.uid).update({
      'absents':(int.parse(user.absents)+1).toString()
    });
  }
  else
  {
    firebaseFirestore.collection('users').doc(user.uid).update({
      'leaves':(int.parse(user.leaves)+1).toString()
    });
  }

}
void attendance(String value,model.Student st)
{
  model.Student student=st;
  student.attendance=int.parse(value);
  firebaseFirestore.collection('attendance').doc(student.date).collection('info').doc(student.uid).update(student.toJson()).whenComplete(() =>print("done"));
  var values=firebaseFirestore.collection("users").doc(st.uid).get();
  values.then((firestoreValue) => {
    _addValuesAdmin(value,firestoreValue)
  });
}
_addValuesAdmin(value,DocumentSnapshot doc)
{
  var userValues =model.User.getValuesFromSnap(doc);
  setGrade(userValues);
  setOtherInfo(value,userValues);
}

void setStudentsAttendanceAdmin()
{
  var values=FirebaseFirestore.instance.collection("users").get();
  values.then((value) =>{
      for(int i=0;i<value.docs.length;i++)
      {
        _decide(model.User.getValuesFromSnap(value.docs[i]))
      }
  });

}
_decide(model.User value)
{
  if(value.email.toString()!='studentsthere@gmail.com')
    markAttendance(value, '1');
}

void requestLeave(model.User user)
{
  markAttendance(user, '10');
}