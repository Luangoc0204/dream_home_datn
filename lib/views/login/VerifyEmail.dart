import 'dart:async';

import 'package:dreamhome/BottomNavigationDirectional.dart';
import 'package:dreamhome/views/home/Home.dart';
import 'package:dreamhome/views/login/Login.dart';
import 'package:dreamhome/views/login/SignUpUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _VerifyEmailPageState();


}
class _VerifyEmailPageState extends State<VerifyEmailPage>{
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified){
      sendVerificationEmail();
      timer = Timer.periodic(
          Duration(seconds: 3),
              (_) => checkEmailVerified()
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    });
    if (isEmailVerified) timer?.cancel();
  }
  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e){
      print("Error send verification email: " + e.toString());
    }
    
  }
  @override
  Widget build(BuildContext context) => isEmailVerified ? SignUpUserPage() :
  Scaffold(
    body: Center(
      heightFactor: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/email_verify.json"),
          Text(
            "Email verification sent successfully",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Please check your email",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                  FirebaseAuth.instance.signOut();
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Material(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                  child: Container(
                    width: 130,
                    height: 50,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person, // Thay bằng icon bạn muốn sử dụng
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Khoảng cách giữa icon và text
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút recent email
                  sendVerificationEmail();
                  FlutterToastr.show("Recent email sent successfully!!!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);


                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    foregroundColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.red)
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                  child: Container(
                    width: 170,
                    height: 50,
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF512F), Color.fromRGBO(244, 92, 67, 0.5169), Color(0xFFFF512F)], // Màu gradient từ dưới lên trên
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh, // Thay bằng icon bạn muốn sử dụng
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Khoảng cách giữa icon và text
                        Text(
                          'Recent Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          )

        ],
      ),
    ),
  );

}