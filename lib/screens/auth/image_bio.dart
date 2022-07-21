import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myams/screens/student/student_home.dart';

import '../../constants.dart';
import '../../methods/auth_methods.dart';
import '../../methods/storage_methods.dart';


class BioImage extends StatefulWidget {
  bool fromSignup;
  String img;
  BioImage({
    Key? key,
    required this.fromSignup,
    required this.img
  }) : super(key: key);

  @override
  _BioImageState createState() => _BioImageState();
}

class _BioImageState extends State<BioImage> {
  Uint8List? _image;
  Color _pickImageShowColor=Colors.black;
  String imgUrl='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgUrl=widget.img;
  }
  final TextEditingController _bioController=TextEditingController();
  pickImage(ImageSource imageSource) async
  {
    final ImagePicker _picker = ImagePicker();
    XFile? xfile= await _picker.pickImage(
        source: imageSource,
        imageQuality: 85
    );
    if(xfile!=null)
    {
      return await xfile.readAsBytes();
    }
    //Prompt that no image is selected
    print("No image is selected");
  }
  void pickImageFromGallery()async
  {
    final ByteData bytes = await rootBundle.load('assets/default_img.png');
    final Uint8List tempImage = bytes.buffer.asUint8List();
    if(widget.fromSignup)
      {
        StorageMethods().uploadImageToStorage("profile_pics",tempImage,);
      }
    Uint8List inList=await pickImage(ImageSource.gallery);
    setState((){
      _image=inList;
      if(_image!=null)
      {
        _pickImageShowColor=Colors.transparent;
      }
      else
      {
        _image=tempImage;
        _pickImageShowColor=Colors.black;
      }
    });
    showFloatingFlushBar(context,"Please wait","Uploading Profile");
    imgUrl=await StorageMethods().uploadImageToStorage("profile_pics",_image!);
    showFloatingFlushBar(context,"Done","Uploaded Successfully");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bioController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.fromSignup==true?'Set Up':'Settings'
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              moveToNextScreen();
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: Text(
                          widget.fromSignup==true?"Lets set up your account":'Add/Change your profile picture',
                          style:const TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: "Times new roman"
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      _image!=null?
                      CircleAvatar(
                        radius:65,
                        backgroundImage: MemoryImage(_image!),
                      ):
                      CircleAvatar(
                        radius:65,
                        backgroundImage: widget.fromSignup==false?imageData??const CircularProgressIndicator():const AssetImage('assets/default_img.png'),
                      ),
                      TextButton(
                          child:const Text(
                              "Selct Image",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          onPressed: () {
                            pickImageFromGallery();
                          }
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      moveToNextScreen();
                    },
                    child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                  widget.fromSignup==true?
                  Column(
                    children: [
                      TextButton(
                          child:const Text(
                              "Skip for now",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          onPressed: () {
                            moveToNextScreen();
                          }
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                          "You can change your profile picture later on",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          )
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                    ],
                  ):Container(),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      AuthMethods().signOut();
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
}
//Void method
void moveToNextScreen()async
{
  //Moving to the next screen.
  await AuthMethods().addPhotoToFirestore(url:imgUrl);
  setImageData(imgUrl);
  widget.fromSignup?Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const StudentHome()),
  ):  Navigator.pop(context);
}
}
