import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/main.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/login/Login.dart';
import 'package:dreamhome/views/login/SplashScreen.dart';
import 'package:dreamhome/views/user/PersonalPage.dart';
import 'package:dreamhome/views/user/ShippingOrder.dart';
import 'package:dreamhome/views/user/UpdatePersonal.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void logout() async {
    Firebase.FirebaseAuth.instance.signOut();
    // Đăng xuất khỏi Google
    await GoogleSignIn().signOut();

    // Xóa dữ liệu lưu trữ
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("haveAccount");
    pushNewScreen(
      context,
      screen: LoginPage(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
  void _getListPostPersonal() async {
    User? currentUser = await context.read<UserViewModel>().currentUser;
    if (currentUser != null)
      await context.read<PostViewModel>().getAllPostPersonal(currentUser.id);
    pushNewScreen(
      context,
      screen: const PersonalPage(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
  void _getListToReceiveOrder() async {
    Cart? cart = await context.read<CartViewModel>().cart;
    if (cart != null) await context.read<OrderViewModel>().getAllNotDeliverForUser(cart.id);
  }
  void _getListToRateOrder() async {
    Cart? cart = await context.read<CartViewModel>().cart;
    if (cart != null) await context.read<OrderViewModel>().getAllPaidForUser(cart.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child:Consumer<UserViewModel>(builder: (context, userViewModel, child) {
              return Stack(
                  children: [
                    Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                          image: AssetImage("assets/img_background_shop.jpg"),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.grey.withOpacity(1), // Màu chuyển đội từ dưới lên
                              mainColor.withOpacity(0),
                              // Màu trong suốt
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 10.w,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.w, ),
                              child: ClipOval(
                                  child: userViewModel.currentUser!.avatar == null
                                      ? Image.asset(
                                    'assets/img_avatar_empty.jpg',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    '${URLImage}user/${userViewModel.currentUser!.avatar}', // Thay thế bằng URL của ảnh
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w,
                                      bottom: 15
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        userViewModel.currentUser.name,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10.w,),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: InkWell(
                                            onTap: (){
                                              pushNewScreen(
                                                context,
                                                screen: const UpdatePersonal(),
                                                withNavBar: false, // OPTIONAL VALUE. True by default.
                                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                              );
                                            },
                                            child: FaIcon(FontAwesomeIcons.penToSquare, size: 25, color: Colors.white)),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                            SizedBox(width: 10.w,),
                          ],
                        ),
                      ),
                    ),
                  ]
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text("Purchase", style: TextStyle(fontSize: 20, color: Colors.black),),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _getListToReceiveOrder();
                    pushNewScreen(
                      context,
                      screen: const ShippingOrderPage(title: "To Receive Order",),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.truckFast, size: 25, color: mainColor),
                      const Text(
                        "To Receive",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _getListToRateOrder();
                    pushNewScreen(
                      context,
                      screen: const ShippingOrderPage(title: "To Rate Order",),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.solidStar, size: 25, color: mainColor),
                      const Text(
                        "To Rate",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.withOpacity(0.4),
            height: 1,
          ),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.4)
                )
              )
            ),
            child: ElevatedButton(
              onPressed: () {
                _getListPostPersonal();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 10.w, 15.h),
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.addressCard, size: 25, color: mainColor),
                  SizedBox(width: 10,),
                  const Text(
                    "Your post",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.4)
                    )
                )
            ),
            child: ElevatedButton(
              onPressed: () {
                logout();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 10.w, 15.h),
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 25, color: mainColor),
                  SizedBox(width: 10,),
                  const Text(
                    "Logout",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );;
  }
}
