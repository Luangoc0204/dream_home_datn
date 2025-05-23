import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AddEditPostPage extends StatefulWidget {
  const AddEditPostPage({super.key, this.post});

  final Post? post;

  @override
  State<AddEditPostPage> createState() => _AddEditPostPageState();
}

class _AddEditPostPageState extends State<AddEditPostPage> {
  late User user;
  TextEditingController contentController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<dynamic> allImages = [];

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() {
    if (widget.post != null) {
      contentController.text = widget.post!.content;
      allImages.addAll(widget.post!.image!);
    }
  }

  void selectImage() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageFileList.addAll(selectedImages);
        allImages.addAll(selectedImages);
      });
    }
  }

  Future<void> addPost() async {
    String content = contentController.text.trim();
    if (content == "")
      FlutterToastr.show("Content is empty!", context,
          duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
    else {
      user = await context.read<UserViewModel>().currentUser!;
      showAlertDialog(context);
      List<File> images = imageFileList.map((e) => File(e.path)).toList();
      Post post = Post.onlyContentAndAuthor(content, user);
      await context.read<PostViewModel>().addPostWithImages(post, images);
      Post postResponse = await context.read<PostViewModel>().post!;
      // await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      if (postResponse.id == '')
        FlutterToastr.show("Failed!", context, duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
      else {
        if (postResponse.id == '')
          FlutterToastr.show("Your post has been posted", context,
              duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> updatePost() async {
    String content = contentController.text.trim();
    if (content == "")
      FlutterToastr.show("Content is empty!", context,
          duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
    else {
      user = await context.read<UserViewModel>().currentUser!;
      showAlertDialog(context);
      List<File> images = imageFileList.map((e) => File(e.path)).toList();
      widget.post!.content = content;
      await context.read<PostViewModel>().updatePostWithImages(widget.post!, images);
      Future.delayed(Duration(seconds: 3));
      debugPrint("Post json edit: " + widget.post!.toJsonEdit().toString());
      Post postResponse = await context.read<PostViewModel>().post!;
      // await Future.delayed(Duration(seconds: 2));
      print("Post response edit: " + postResponse.toString());
      if (postResponse.id == '') {
        Navigator.pop(context);
        FlutterToastr.show("Failed!", context, duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
      }
      else {
        FlutterToastr.show("Your post has been updated", context,
            duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
        await context.read<PostViewModel>().getAllPost(user.id);
        User currentUser = await context.read<UserViewModel>().currentUser;
        await context.read<PostViewModel>().getAllPostPersonal(currentUser.id);
        List<Post> listPost = await context.read<PostViewModel>().listPostPersonal;
        print("List post: " + listPost.toString());
        Future.delayed(Duration(milliseconds: 1500));
        // Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pop();
      }
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
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.post == null ? "Create post" : "Update post",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (widget.post == null) {
                      addPost();
                    } else {
                      updatePost();
                    }
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Colors.red)),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                    child: Container(
                      width: 80,
                      height: 40,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF512F),
                            Color.fromRGBO(244, 92, 67, 0.5169),
                            Color(0xFFFF512F)
                          ], // Màu gradient từ dưới lên trên
                        ),
                        borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.5),
              thickness: 1,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                children: [
                  Consumer<UserViewModel>(builder: (context, userViewModel, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                            child: userViewModel.currentUser!.avatar == null
                                ? Image.asset(
                                    'assets/img_avatar_empty.jpg',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    '${URLImage}user/' + userViewModel.currentUser.avatar, // Thay thế bằng URL của ảnh
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )),
                        Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            userViewModel.currentUser.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: "Share your moments",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      maxLines: null,
                    ),
                  ),
                  allImages.length > 1
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 0),
                          itemCount: allImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: allImages[index] is String
                                      ? Image.network(
                                          '${URLImage}post/' + allImages[index],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(allImages[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (widget.post != null && index < widget.post!.image!.length) {
                                          widget.post!.image!.removeAt(index);
                                        } else if (widget.post != null && index >= widget.post!.image!.length) {
                                          imageFileList.removeAt(index - widget.post!.image!.length);
                                        } else if (widget.post == null) {
                                          imageFileList.removeAt(index);
                                        }
                                        allImages.removeAt(index);
                                      });
                                    },
                                    child: FaIcon(FontAwesomeIcons.xmark, size: 15, color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                        )
                      : allImages.isEmpty
                          ? SizedBox()
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: allImages[0] is String
                                        ? Image.network(
                                            '${URLImage}post/' + allImages[0],
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(imageFileList[0].path),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (widget.post != null) {
                                            widget.post!.image!.removeAt(0);
                                          } else if (widget.post == null) {
                                            imageFileList.removeAt(0);
                                          }
                                          allImages.removeAt(0);
                                        });
                                      },
                                      child: FaIcon(FontAwesomeIcons.xmark, size: 15, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ))
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.5),
              thickness: 1,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: FaIcon(FontAwesomeIcons.solidImage, size: 30, color: Color(0xFF00C1A2)),
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
