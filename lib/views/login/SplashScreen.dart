import 'package:dreamhome/BottomNavigationDirectional.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/login/Login.dart';
import 'package:dreamhome/views/login/VerifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double logoTop;
  double opacity = 0;
  var auth = Firebase.FirebaseAuth.instance;
  var isLogin = false;

  checkLogin() async {
    auth.authStateChanges().listen((Firebase.User? user) {
      if (user != null && mounted){
        setState(() {
          isLogin = true;
        });
        getCurrentUser();
      }
    });
  }



  @override
  void initState() {
    super.initState();
    logoTop = 100.0;
    startAnimation();
  }
  Future<void> getCurrentUser() async {
    String? email = Firebase.FirebaseAuth.instance.currentUser!.email;
    if (email != null){
      await context.read<UserViewModel>().getCurrentUser(email);
    }
    User? currentUser = await  context.read<UserViewModel>().currentUser;
    if (currentUser != null){
      await context.read<CartViewModel>().getCart(currentUser.id);

    }
    print("Current User: " + currentUser.toString());
  }
  Future<void> startAnimation() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      logoTop = 200.0;
      opacity = 1;
    });

    await checkLogin();
    await Future.delayed(Duration(seconds: 3));
    bool? haveAccount = false;
    // Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
    // prefs.then((pref) =>() async {
    //   haveAccount = await pref.getBool('haveAccount') ?? false;
    //   print("Have account splash: " + haveAccount.toString());
    //
    // });
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      haveAccount = prefs.getBool('haveAccount') ?? false;
      print("Have account splash: " + haveAccount.toString());
    });
    // Chuyển hướng đến trang chính hoặc màn hình tiếp theo tại đây
    if (haveAccount!)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationDirectional()),
      );
    else if (isLogin && context.read<UserViewModel>().currentUser!=null){
      if (haveAccount == false) prefs.setBool('haveAccount', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationDirectional()),
      );
    }

    else if (isLogin)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmailPage()),
      );
    else
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background image
            Image.asset(
              'assets/img_background_splash.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
                top: 200,
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 1500),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/ic_logo.svg',
                        height: 100.0,
                        width: 100.0,
                        color: Colors.white,
                      ),
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
                    ],
                  ),
                )
            )



          ],
        ),
      )

    );
  }
}
