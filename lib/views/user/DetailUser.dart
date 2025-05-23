import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/DetailChatUser.dart';
import 'package:dreamhome/views/home/PostBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class DetailUserPage extends StatefulWidget {
  final User user;
  const DetailUserPage({super.key, required this.user});

  @override
  State<DetailUserPage> createState() => _DetailUserPageState();
}

class _DetailUserPageState extends State<DetailUserPage> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getListPost();
  }
  void _getCurrentUser() async {
    currentUser = await context.read<UserViewModel>().currentUser;
  }
  _getListPost() async {
    await context.read<PostViewModel>().getAllPostPersonal(widget.user.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child:Stack(
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
                                child: widget.user.avatar == null
                                    ? Image.asset(
                                  'assets/img_avatar_empty.jpg',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                                    : Image.network(
                                  '${URLImage}user/${widget.user.avatar}', // Thay thế bằng URL của ảnh
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
                                  widget.user.name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                )
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Consumer<UserViewModel>(
                            builder: (BuildContext context, UserViewModel userViewModel, Widget? child) {
                              return Container(
                                constraints: BoxConstraints(minWidth: 70),
                                padding: EdgeInsets.zero,

                                child: ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                                      backgroundColor: mainColor,
                                      elevation:0,
                                      shape:RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(5)
                                      )
                                  ),
                                  onPressed: () {
                                    pushNewScreen(
                                      context,
                                      screen: DetailChatUserPage(receiverUserName: widget.user.name, receiverUserId: widget.user.id, receiverUserAvatar: widget.user.avatar, senderUserName: userViewModel.currentUser.name, senderUserId: userViewModel.currentUser.id, senderUserAvatar: userViewModel.currentUser.avatar, currentUserId: currentUser!.id,),
                                      withNavBar: false, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(FontAwesomeIcons.facebookMessenger, size: 14, color: Colors.white),
                                      SizedBox(width: 4.w,),
                                      Text("Chat", style: TextStyle(color: Colors.white, fontSize: 14),)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 20.w,)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top - 10.h,
                    left: 5.w,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.white)
                    ),
                  )
                ]
            )
          ),
          Expanded(
            child: Consumer<PostViewModel>(
                builder: (context, postViewModel, child){
                  if (postViewModel.listPostPersonal.isEmpty){
                    return Center(
                      child: Text(
                        "There are no posts", style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 0),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: postViewModel.listPostPersonal.length,
                    itemBuilder: (context, index) {
                      return PostBox(post: postViewModel.listPostPersonal[index]);
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
