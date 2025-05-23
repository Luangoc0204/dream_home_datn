import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UpdatePersonal extends StatefulWidget {
  const UpdatePersonal({super.key});

  @override
  State<UpdatePersonal> createState() => _UpdatePersonalState();
}

class _UpdatePersonalState extends State<UpdatePersonal> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? avatarImagePicker = null;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
    nameController.text = await context.read<UserViewModel>().currentUser.name;

  }
  Future<void> updateInformation() async {
    String name = nameController.text.trim();
    if (name == "")
      FlutterToastr.show("Name is empty!", context, duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
    else {
      User user = await context.read<UserViewModel>().currentUser!;
      showAlertDialog(context);
      user.name = name;
      if (avatarImagePicker != null) {
        await context.read<UserViewModel>().updateUser(user, File(avatarImagePicker!.path));
      } else {
        await context.read<UserViewModel>().updateUser(user, null);
      }
      await context.read<PostViewModel>().getAllPost(user.id);
      // await Future.delayed(Duration(seconds: 2));
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
          Expanded(child: Consumer<UserViewModel>(
            builder: (BuildContext context, UserViewModel userViewModel, Widget? child) {
              emailController.text = userViewModel.currentUser.email;
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
                              : userViewModel.currentUser!.avatar == null
                                  ? InkWell(
                                      onTap: () {
                                        selectImage();
                                      },
                                      child: Image.asset(
                                        'assets/img_avatar_empty.jpg',
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
                                        '${URLImage}user/' +
                                            userViewModel.currentUser.avatar, // Thay thế bằng URL của ảnh
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
                      child:
                          Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
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
                        onChanged: (value) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text("Address",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextField(
                        enabled: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {},
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
