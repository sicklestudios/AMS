import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../methods/auth_methods.dart';
import 'image_bio.dart';
import 'login.dart';


class MySignup extends StatefulWidget {
  const MySignup({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MySignup> {
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passController=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'),
              fit: BoxFit.fill
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 45,left: 45,top: 100),
              child: Column(
                children: const [
                   Text(
                    "Welcome",
                    style:TextStyle(
                        color: Colors.white,
                        fontSize: 45.0
                    ) ,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Create Account",
                    style:TextStyle(
                        color: Colors.white,
                        fontSize: 25.0
                    ) ,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  right: 30,
                  left: 30,
                  top: MediaQuery.of(context).size.height*0.3,
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Stack(
                    //   children: [
                    //     _image!=null?
                    //     CircleAvatar(
                    //       radius:65,
                    //       backgroundImage: MemoryImage(_image!),
                    //     ):
                    //     const CircleAvatar(
                    //       radius:65,
                    //       backgroundImage: AssetImage('assets/default_img.png'),
                    //     ),
                    //     Positioned(
                    //       bottom: 25,
                    //       left: 20,
                    //       child: IconButton(
                    //           color:  _pickImageShowColor,
                    //           onPressed: () async {
                    //             pickImageFromGallery();
                    //           },
                    //           iconSize: 75,
                    //           icon: const Icon(
                    //               Icons.add
                    //           )
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Name",
                          // hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      controller: _nameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                      height: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:[
                            const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            CircleAvatar(
                              radius:25,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: (){
                                    signUp();
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
                              icon: const Icon(Icons.login),
                              label: const Text('Continue with Google')
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 30,
                        left: 30,
                        top: MediaQuery.of(context).size.height*0.08,
                      ),
                      child: Column(
                        children:[
                          const Text(
                              "Already have an account",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )
                          ),
                          TextButton(
                              child:
                              const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context)=>const LoginScreen()
                                  )
                                );
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
  void signUp() async
  {
    String checkValue=checkEmpty(_emailController.text, _passController.text);
    if(checkValue=="continue")
      {
        setState(() {
          showFloatingFlushBar(context,"Please Wait","Registering");
        });
        String res=await AuthMethods().signUpUser(
            name: _nameController.text,
            email: _emailController.text,
            password: _passController.text,
        );
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
      else
      {
        showFloatingFlushBar(context,"Failed",checkValue);
      }
  }
}
