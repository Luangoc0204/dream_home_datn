import 'dart:async';
import 'dart:ui';

import 'package:dreamhome/BottomNavigationDirectional.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/views/login/ForgotPassword.dart';
import 'package:dreamhome/views/login/VerifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  bool _showSignUpPage = false;
  bool _isPasswordMismatch = false;
  TextEditingController _emailLoginController = TextEditingController();
  TextEditingController _passwordLoginController = TextEditingController();
  TextEditingController _emailSignUpController = TextEditingController();
  TextEditingController _passwordSignUpController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }

  Future<void> signInWithGoogle() async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      // Đăng nhập vào Firebase bằng Google Credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Người dùng đã đăng nhập thành công
      print('Đăng nhập thành công: ${userCredential.user?.displayName}');

      // Đoạn code tiếp theo tùy thuộc vào việc bạn muốn thực hiện điều gì sau khi đăng nhập thành công.
      // Ví dụ: chuyển hướng sang trang HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationDirectional()),
      );
    }  catch (error) {
      print('Đăng nhập thất bại: $error');
      // Xử lý lỗi đăng nhập nếu cần
    }

  }
  Future<void> login() async {
    try {
      if (_emailLoginController.text.trim() != "" && _passwordLoginController.text.trim() != ""){
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailLoginController.text.trim(),
            password: _passwordLoginController.text.trim()
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
      } else {
        FlutterToastr.show("Email or password is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        FlutterToastr.show("No user found for that email!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      } else if (e.code == 'wrong-password') {
        FlutterToastr.show("Wrong password provided for that user!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      } else if (e.code == 'invalid-credential') {
        FlutterToastr.show("Wrong mode of login!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      }
      else {
        print('Other FirebaseAuthException: $e');
      }
    }
  }
  Future<void> signUp() async {
    try {
      if (_emailSignUpController.text.trim() == "" && _passwordSignUpController.text.trim() == "") {
        FlutterToastr.show("Email or password is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      } else if (_confirmPasswordController.text.trim() == ""){
        FlutterToastr.show("Uncomfirmed password!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      } else if (_isPasswordMismatch) {
        FlutterToastr.show("Passwords do not match!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      } else if (_emailSignUpController.text.trim() != "" && _passwordSignUpController.text.trim() != ""){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailSignUpController.text.trim(),
        password: _passwordSignUpController.text.trim()
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
      }

    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        FlutterToastr.show("The password provided is too weak!!!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      } else if (e.code == 'email-already-in-use') {
        FlutterToastr.show("The account already exists for that email!!!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

      }
    }
    catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: null,
      body: PopScope(
        canPop:  false,
        child: Stack(
          children: [
            // Background là một file SVG
            // Đặt hình ảnh hoặc SVG vào Asset
            // Ví dụ: AssetImage('assets/backgrou nd.svg')



            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Image.asset('assets/img_apartment_login.jpg', fit: BoxFit.cover,)
            ),
            Positioned(
                top: 170,
                left: 0,
                right: 0,
                height: 30,
                child: SvgPicture.asset('assets/img_building_login.svg', fit: BoxFit.cover,)
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/img_background_login_2.png',
                fit: BoxFit.cover,
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              bottom: -20,
              left: _showSignUpPage ? -MediaQuery.of(context).size.width : -100,
              child: Transform(
                transform: Matrix4.identity()..rotateZ(-10 * (3.141592653589793 / 180))..scale(-1.0, 1.0),
                alignment: Alignment.center, // Đặt điểm trung tâm để flip horizontal
                child: Image.asset(
                  "assets/img_sofa_blur.png",
                  fit: BoxFit.cover,
                  width: 400,  // Đặt kích thước của hình ảnh nếu cần thiết
                  height: 400,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              left: _showSignUpPage ? -MediaQuery.of(context).size.width : 0 ,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: GlassmorphicContainer(
                      width: 300,
                      height: 400,
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
                          Color(0xFFffffff).withOpacity(0.5),
                          Color(0xFFFFFFFF).withOpacity(0.5),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          // Hình ảnh trước card
                          OutlinedText(
                            text: Text(
                              "DREAMHOME",
                              style: TextStyle(
                                color: mainColor,
                                fontFamily: 'NicoMoji',
                                fontSize: 30,
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
                          Container(
                            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFormField(
                                  controller: _emailLoginController,
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
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _passwordLoginController,
                                  style: TextStyle(color: mainColor),
                                  obscureText: true,

                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.6),
                                    hintText: 'Password...',
                                    hintStyle: TextStyle(color: mainColor),
                                    prefixIcon: Icon(
                                      Icons.lock,
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Xử lý khi nhấn vào dòng chữ
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                      );
                                    },
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(color: mainColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                ElevatedButton(
                                  onPressed: () {
                                    // Xử lý khi nhấn nút login
                                    login();
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
                                    borderRadius: BorderRadius.circular(20.0), // Bo tròn góc của nút
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFFFF512F), Color.fromRGBO(244, 92, 67, 0.5169), Color(0xFFFF512F)], // Màu gradient từ dưới lên trên
                                        ),
                                        borderRadius: BorderRadius.circular(20.0), // Bo tròn góc của nút
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 2, // Độ dày của đường kẻ
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text("or", style: TextStyle(color: mainColor)),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 2, // Độ dày của đường kẻ
                                      ),
                                    ),
                                  ],
                                ),
                                Text("Login with", style: TextStyle(color: mainColor)),
                                SizedBox(height: 10,),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10), //radius cho widget
                                    color: Colors.white,),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),//radius cho hiệu ứng
                                      onTap: () {
                                        signInWithGoogle();
                                      },
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/ic_google.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have account ?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Xử lý khi nhấn Sign up
                                          setState(() {
                                            _showSignUpPage = !_showSignUpPage;
                                          });
                                        },
                                        child: Text(
                                          " Sign up",
                                          style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          )
                        ],
                      ),

                    ),
                  )
              ),
            ),

            // Card dạng glassmorphism
            AnimatedPositioned(
              duration: Duration(milliseconds: 630),
              bottom: -5,
              left: _showSignUpPage ? MediaQuery.of(context).size.width-200 : MediaQuery.of(context).size.width*2,
              child: Transform(
                transform: Matrix4.identity()..rotateZ(10 * (3.141592653589793 / 180))..scale(-1.0, 1.0),
                alignment: Alignment.center, // Đặt điểm trung tâm để flip horizontal
                child: Image.asset(
                  "assets/img_home.png",
                  fit: BoxFit.cover,
                  width: 250,
                  height: 250,
                ),
              ),
            ),
            // SIGN UP
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              left: _showSignUpPage ? 0 : MediaQuery.of(context).size.width ,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: GlassmorphicContainer(
                      width: 300,
                      height: 400,
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
                          Color(0xFFffffff).withOpacity(0.5),
                          Color(0xFFFFFFFF).withOpacity(0.5),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          // Hình ảnh trước card
                          OutlinedText(
                            text: Text(
                              "DREAMHOME",
                              style: TextStyle(
                                color: mainColor,
                                fontFamily: 'NicoMoji',
                                fontSize: 30,
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
                          Container(
                            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFormField(
                                  controller: _emailSignUpController,
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
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _passwordSignUpController,
                                  obscureText: true,
                                  style: TextStyle(color: mainColor),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.6),
                                    hintText: 'Password...',
                                    hintStyle: TextStyle(color: mainColor),
                                    prefixIcon: Icon(
                                      Icons.lock,
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
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  style: TextStyle(color: mainColor),
                                  onChanged: (value) {
                                    // Kiểm tra tự động khi bắt đầu nhập vào "confirm password"
                                    if (_passwordSignUpController.text != _confirmPasswordController.text) {
                                      setState(() {
                                        _isPasswordMismatch = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isPasswordMismatch = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.6),
                                    hintText: 'Comfirm Password...',
                                    hintStyle: TextStyle(color: mainColor),
                                    prefixIcon: Icon(
                                      Icons.password,
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
                                if (_isPasswordMismatch)
                                  Text(
                                    'Passwords do not match!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                SizedBox(height: 20,),

                                ElevatedButton(
                                  onPressed: () {
                                    // Xử lý khi nhấn nút sign up
                                    signUp();
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
                                    borderRadius: BorderRadius.circular(20.0), // Bo tròn góc của nút
                                    child: Container(
                                      width: 150,
                                      height: 50,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFFFF512F), Color.fromRGBO(244, 92, 67, 0.5169), Color(0xFFFF512F)], // Màu gradient từ dưới lên trên
                                        ),
                                        borderRadius: BorderRadius.circular(20.0), // Bo tròn góc của nút
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_isPasswordMismatch)
                                  SizedBox(height: 45,),
                                if (!_isPasswordMismatch)
                                  SizedBox(height: 60,),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account ?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Xử lý khi nhấn Sign up
                                          setState(() {
                                            _showSignUpPage = !_showSignUpPage;
                                          });
                                        },
                                        child: Text(
                                          " Login",
                                          style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          )
                        ],
                      ),

                    ),
                  )
              ),
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 580),
                top: 70,
                left: _showSignUpPage ? -MediaQuery.of(context).size.width+250 : MediaQuery.of(context).size.width-100,
                child: Transform.rotate(
                  angle: 30 * (3.141592653589793 / 180), // Góc xoay 30 độ (chuyển đổi sang radian)
                  child: Image.asset(
                    "assets/img_pencil.png",
                    fit: BoxFit.cover,
                    width: 300,  // Đặt kích thước của hình ảnh nếu cần thiết
                    height: 300,
                  ),
                )
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              bottom: 20,
              left: _showSignUpPage ? -MediaQuery.of(context).size.width+300 : MediaQuery.of(context).size.width-120,
              child: Transform(
                transform: Matrix4.identity()..rotateZ(15 * (3.141592653589793 / 180))..scale(-1.0, 1.0),
                alignment: Alignment.center, // Đặt điểm trung tâm để flip horizontal
                child: Image.asset(
                  "assets/img_ball_chair.png",
                  fit: BoxFit.cover,
                  width: 170,
                  height: 170,
                ),
              ),
            ),

          ],
        ),
      )

    );
  }
}
