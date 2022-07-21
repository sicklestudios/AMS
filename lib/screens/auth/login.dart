import 'package:flutter/material.dart';
import 'package:myams/screens/student/student_home.dart';
import '../../constants.dart';
import '../../methods/auth_methods.dart';
import 'image_bio.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passController=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/login.png'),
        //       fit: BoxFit.fill
        //     )
        // ),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 45,left: 45,top: 150),
              child: const Text(
                "Welcome Back",
                style:TextStyle(
                  color: Colors.black,
                  fontSize: 50.0
                ) ,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  right: 30,
                  left: 30,
                  top: MediaQuery.of(context).size.height*0.45,
                ),
                child:Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Email",
                          // hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      obscureText: true,//To hide the password
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Password",
                          // hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      controller: _passController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children:[
                        TextButton(
                            child:const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            onPressed: () {}
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:[
                            const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )
                            ),
                            CircleAvatar(
                              radius:25,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                color: Colors.white,
                                onPressed: (){
                                  login();
                                },
                                icon: const Icon(Icons.arrow_forward_ios)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                              onPressed: (){
                                googleSignIn();
                              },
                              icon: Icon(Icons.login),
                              label: Text('Continue with Google')
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 30,
                        left: 30,
                        top: MediaQuery.of(context).size.height*0.05,
                      ),
                      child: Column(
                        children:[
                          const Text(
                              "Don't have an account",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )
                          ),
                          TextButton(
                              child:const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context)=>const MySignup()
                                ));
                              }
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void googleSignIn()async
  {
    String res=await AuthMethods().signInWithGoogle();
    setState(() {
      if(res=="Success")
      {
        showFloatingFlushBar(context,res,"Successfully Registered");
        Future.delayed(const Duration(seconds: 2), (){
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BioImage(fromSignup: true,img: '',)),
          );
        });
      }
      else
      {
        showFloatingFlushBar(context,"Failed",res);
      }
    });
  }
  String checkEmpty(String email,String password){
    if(email.isNotEmpty)
    {
      if(password.isNotEmpty)
      {
        return"continue";
      }
      else
      {
        return"Password cannot be empty";
      }
    }
    else
    {
      return"Email cannot be empty";
    }
  }
  void login() async
  {
    String checkValue=checkEmpty(_emailController.text, _passController.text);
    if(checkValue=="continue")
      {
        setState(() {
          showFloatingFlushBar(context,"Success","Logging up");
        });
        String res=await AuthMethods().loginUser(
            email: _emailController.text,
            password: _passController.text,
            context: context
        );
        setState(() {
          if(res=="Success")
          {
            showFloatingFlushBar(context,res,"Successfully Logged in");
            Future.delayed(const Duration(seconds: 2), (){
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => StudentHome()),
              );
            });
          }
          else
          {
            showFloatingFlushBar(context,"Failed",res);

          }
        });
      }
    else
      {
        showFloatingFlushBar(context,"Failed",checkValue);
      }
  }
}
