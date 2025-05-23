import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RegisteringBusinessPage extends StatefulWidget {
  const RegisteringBusinessPage({super.key});

  @override
  State<RegisteringBusinessPage> createState() => _RegisteringBusinessPageState();
}

class _RegisteringBusinessPageState extends State<RegisteringBusinessPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  _addShop() async {
    if (nameController.text.trim().isEmpty){
      FlutterToastr.show("Name is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
    } else if (addressController.text.trim().isEmpty){
      FlutterToastr.show("Address is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
    } else {
      showAlertDialog(context);
      User user = await context.read<UserViewModel>().currentUser;
      Shop shop = Shop.noId(nameController.text.trim(), addressController.text.trim(), user);
      await context.read<ShopViewModel>().addShop(shop);
      FlutterToastr.show("Registering Business successfully", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
      Navigator.pop(context);
      Navigator.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.black)),
                    ),
                  ),
                  Text(
                    "Registering Business",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  const Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: 20.h,),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: "Enter the shop's name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {

              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "Enter the shop's address",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {

              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: ElevatedButton(
              onPressed: (){
                _addShop();
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
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF512F), Color.fromRGBO(244, 92, 67, 0.5169), Color(0xFFFF512F)], // Màu gradient từ dưới lên trên
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
