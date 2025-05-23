import 'package:dreamhome/BottomNavigationDirectional.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:outlined_text/models/outlined_text_stroke.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpUserPage extends StatefulWidget {
  const SignUpUserPage({super.key});

  @override
  State<SignUpUserPage> createState() => _SignUpUserPageState();
}

class _SignUpUserPageState extends State<SignUpUserPage> {
  bool haveAccount = false;
  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  Future<void> getCurrentUser() async {
    String? email =await Firebase.FirebaseAuth.instance.currentUser!.email;
    if (email != null){
      await context.read<UserViewModel>().getCurrentUser(email);
    }
    User? currentUser = await  context.read<UserViewModel>().currentUser;
    if (currentUser != null){
      print("Current User: " + currentUser.toString());
      setState(() {
        haveAccount = true;
      });
    }
  }
  addUser() async{
    if (_nameController.text.trim() != ""){
      showAlertDialog(context);
      User user = User.noId(_nameController.text.trim(), Firebase.FirebaseAuth.instance.currentUser!.email);
      await context.read<UserViewModel>().addUser(user);
      User userResponse =  await context.read<UserViewModel>().currentUser;
      print("Current User: " + userResponse.toString());
      if (userResponse != null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          haveAccount = true;
          prefs.setBool('haveAccount', true);
        });
        Navigator.pop(context);

      } else {
        FlutterToastr.show("Failed to create account!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
      }
    } else {
      FlutterToastr.show("Name is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

    }
  }
  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
        content: Container(
          child: Lottie.asset("assets/lottie/loading_hand.json"),
        )
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) => haveAccount ? BottomNavigationDirectional() :
    Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 450),
                  child: Lottie.asset("assets/lottie/create_account.json", height: 300),
                ),
              )
          ),
          Positioned.fill(
              child: Center(
                child: GlassmorphicContainer(
                  width: 300,
                  height: 250,
                  borderRadius: 20,
                  blur: 10,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFffffff).withOpacity(0.5),
                      Color(0xFFFFFFFF).withOpacity(0.5),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00ddb3).withOpacity(0.5),
                      Color(0xFF00ddb3).withOpacity(0.5),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      // Hình ảnh trước card
                      OutlinedText(
                        text: Text(
                          "Create account",
                          style: TextStyle(
                            color: Color(0xFF00ddb3),
                            fontFamily: 'NicoMoji',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        strokes: [
                          OutlinedTextStroke(
                              color: Colors.white,
                              width: 2
                          )
                        ],
                      ),
                      Text("Enter your name ", style: TextStyle(fontSize: 25),),
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              maxLength: 30,
                              style: TextStyle(color: mainColor),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                hintText: 'Name...',
                                hintStyle: TextStyle(color: mainColor),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: mainColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            ElevatedButton(
                              onPressed: () {
                                // Xử lý khi nhấn nút sign up
                                addUser();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                backgroundColor: Color(0xFF00ddb3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                              ),
                              child: Text(
                                'Create account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                ),
              ),
          )
        ],
      ),
    );

}
