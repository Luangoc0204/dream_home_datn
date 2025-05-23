import 'dart:io';

import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';

class UpdateShopPage extends StatefulWidget {
  const UpdateShopPage({super.key});

  @override
  State<UpdateShopPage> createState() => _UpdateShopPageState();
}

class _UpdateShopPageState extends State<UpdateShopPage> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? avatarImagePicker = null;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void selectImage() async {
    final XFile? selectedImages = await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      setState(() {
        avatarImagePicker = selectedImages;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _getData();

  }
  _getData() async{
    nameController.text = await context.read<ShopViewModel>().currentShop.name;
    addressController.text = await context.read<ShopViewModel>().currentShop.address;

  }
  Future<void> updateInformation() async {
    String name = nameController.text.trim();
    if (name == "")
      FlutterToastr.show("Name is empty!", context, duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
    else {
      Shop shop = await context.read<ShopViewModel>().currentShop!;
      showAlertDialog(context);
      shop.name = name;
      if (avatarImagePicker != null) {
        await context.read<ShopViewModel>().updateShop(shop, File(avatarImagePicker!.path));
      } else {
        await context.read<ShopViewModel>().updateShop(shop, null);
      }
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      FlutterToastr.show("Update information successfully!", context,
          duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
      Navigator.of(context).pop();
    }
  }
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: Container(
          child: Lottie.asset("assets/lottie/loading_hand.json"),
        ));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                    "Update Information",
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
          SizedBox(
            height: 20,
          ),
          Expanded(child: Consumer<ShopViewModel>(
            builder: (BuildContext context, ShopViewModel shopViewModel, Widget? child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ClipOval(
                          child: avatarImagePicker != null
                              ? ClipOval(
                            child: InkWell(
                              onTap: () {
                                selectImage();
                              },
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Image.file(
                                  File(avatarImagePicker!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                              : shopViewModel.currentShop!.avatar == null
                              ? InkWell(
                            onTap: () {
                              selectImage();
                            },
                            child: Image.asset(
                              'assets/img_shop_empty.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                              : InkWell(
                            onTap: () {
                              selectImage();
                            },
                            child: Image.network(
                              '${URLImage}shop/' +
                                  shopViewModel.currentShop.avatar, // Thay thế bằng URL của ảnh
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                backgroundColor: mainColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Đặt bo góc cho border
                                ),
                              ),
                              onPressed: (){
                                updateInformation();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Send",
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),

        ],
      ),
    );
  }
}
