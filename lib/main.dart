import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myams/constants.dart';
import 'package:myams/providers/user_provider.dart';
import 'package:myams/screens/auth/login.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/admin/admin_home.dart';
import 'screens/student/student_home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  runApp(const MyApp());
}


Widget decide(val)
{
  if(val.email=='studentsthere@gmail.com')
  {
    return const AdminHome();
  }
  else
  {
    return const StudentHome();
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'AMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyLogin(),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.active)
              {
                if(snapshot.hasData){
                  return decide(snapshot.data!);
                }
                else if(snapshot.hasError)
                {
                  return Center(
                    child: Text(
                        snapshot.error.toString()
                    ),
                  );
                }
              }
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return const Center(
                  child: CircularProgressIndicator(
                  ),
                );
              }
              return const LoginScreen();
            }
        ),
      ),
    );
  }
}

