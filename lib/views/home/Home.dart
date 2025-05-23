import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/repository/service/PostService.dart';
import 'package:dreamhome/viewmodels/ChatViewModel.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/AddEditPost.dart';
import 'package:dreamhome/views/home/ChattingUser.dart';
import 'package:dreamhome/views/home/DetailPost.dart';
import 'package:dreamhome/views/home/PostBox.dart';
import 'package:dreamhome/views/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:dreamhome/data/color.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firebase.User? currentUser = Firebase.FirebaseAuth.instance.currentUser;
  User? currentUserApi;
  final ChatViewModel _chatViewModel = ChatViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllPost();
  }
  Future<void> _getAllPost() async {
    currentUserApi = await context.read<UserViewModel>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DREAMHOME",
                    style: TextStyle(
                      color: mainColor,
                      fontFamily: 'NicoMoji',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Consumer<UserViewModel>(
                    builder: (BuildContext context, UserViewModel userViewModel, Widget? child) {
                      if (userViewModel.currentUser == null){
                        return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                      }
                      return GestureDetector(
                        onTap: (){
                          pushNewScreen(
                            context,
                            screen: ChattingUserPage(currentUser: userViewModel.currentUser,),
                            withNavBar: false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: StreamBuilder<int>(
                          stream: _chatViewModel.getUnreadConversationsCount(userViewModel.currentUser.id),
                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Hiển thị một số gì đó khi đang chờ dữ liệu
                              return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                            } else if (snapshot.hasError) {
                              // Xử lý lỗi nếu có
                              return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                            } else {
                              if (snapshot.data == 0){
                                return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                              }
                              // Hiển thị nội dung chính
                              return badges.Badge(
                                badgeContent: Text(
                                  snapshot.data.toString(), // Hiển thị số tin nhắn chưa đọc
                                  style: TextStyle(color: Colors.white),
                                ),
                                child: FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(
                height: 1,
                color: mainColor,
                thickness: 1,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<UserViewModel>(
                            builder: (context, userViewModel, child){
                              if (userViewModel.currentUser == null){
                                return ClipOval(
                                    child: Image.asset(
                                      'assets/img_avatar_empty.jpg',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                );
                              } else {
                                return ClipOval(
                                    child: userViewModel.currentUser!.avatar == null  ? Image.asset(
                                      'assets/img_avatar_empty.jpg',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ) : Image.network(
                                      '${URLImage}user/'+userViewModel.currentUser.avatar, // Thay thế bằng URL của ảnh
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                );
                              }

                            }
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: GestureDetector(
                              onTap: (){
                                pushNewScreen(
                                  context,
                                  screen: AddEditPostPage(),
                                  withNavBar: false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: mainColor.withOpacity(0.8),
                                    width: 2.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Share your moments',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    FaIcon(FontAwesomeIcons.solidImage, size: 30, color: Color(0xFF00C1A2)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 5, color: Color(0xFF1C1E21).withOpacity(0.1), thickness: 5,),
      
                  // Các phần của ListView khác
                  Consumer<PostViewModel>(
                      builder: (context, postViewModel, child){
                        // print("List post: " + postViewModel.listPost.toString());
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: postViewModel.listPost.length,
                          itemBuilder: (context, index) {
                            return PostBox(post: postViewModel.listPost[index], owner:  currentUserApi == postViewModel.listPost[index].author.id ? true : false);
                          },
                          reverse: true,
                        );
                      }
                  )

                ],
              ),
            ),
          ],
        ),

    );
  }
}

