import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/views/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  Future<void> sendResetPasswordEmail() async {
    if (_emailController.text.trim() == "") {
      FlutterToastr.show("Email is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

    } else {
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(),)
        );

        // Kiểm tra phương thức đăng nhập liên kết với email
        var signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailController.text.trim());

        if (signInMethods.isNotEmpty) {
          // Email tồn tại trong hệ thống, gửi email đặt lại mật khẩu
          await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
          Navigator.pop(context);
          FlutterToastr.show("Password reset email sent", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
        } else {
          // Email không tồn tại
          Navigator.pop(context);
          FlutterToastr.show("No user found for that email!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        if (e.code == 'invalid-credential') {
          FlutterToastr.show("Wrong mode of login!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
        } else {
          FlutterToastr.show("Failed!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
          print('Other FirebaseAuthException: $e');
        }
      }
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset("assets/lottie/reset_password.json"),
              Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "Enter the email address associated with your account and we'll send you a link to reset your password. ",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: mainColor),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    hintText: 'Email...',
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
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Material(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 130,
                        height: 50,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
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
                      // Xử lý khi nhấn nút login
                      sendResetPasswordEmail();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Material(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 130,
                        height: 50,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Send',
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
      ),
    );
  }
}
