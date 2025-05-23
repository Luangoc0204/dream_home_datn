import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/PostBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<UserViewModel>(builder: (context, userViewModel, child) {
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
                                child: Text(
                                  userViewModel.currentUser.name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                )
                            ),
                          ),
                          SizedBox(width: 10.w,),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top - 10.h,
                    left: 5.w,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.white)
                    ),
                  )
                ]
            );
          }),
          Expanded(
            child: Consumer<PostViewModel>(
                builder: (context, postViewModel, child){
                  List<Post> listPost = postViewModel.listPostPersonal;
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 0),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listPost.length,
                    itemBuilder: (context, index) {
                      return PostBox(post: listPost[index], owner: true,);
                    },
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
