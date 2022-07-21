// import 'package:chatapp/models/chat.dart';
// import 'package:chatapp/screens/home_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';
//
// import '../constant_files/utils.dart';
//
// void sendMessage(String text)
// {
//   if(text.isNotEmpty)
//     {
//       var now=DateTime.now();
//       String cDate = DateFormat("yyyy-MM-dd").format(now);
//       String time=DateFormat.jm().format(now);
//       String seconds=now.second.toString();
//       String id="123";
//       if(kIsWeb)
//         id='321';
//       ChatModel chatModel=ChatModel(sendersUid: id, message: text, time: time, read: 'no',date: cDate,seconds:seconds,timeStamps: now.millisecondsSinceEpoch.toString());
//       // ChatModel chatModel=ChatModel(sendersUid: '123', message: text, time: time, read: 'no',date:"$cDate-$time-$seconds",seconds:seconds);
//       firebaseFirestore.collection('uid1').doc('messages').collection('uid1+uid2').doc().set(chatModel.toJson());
//     }
//
// }