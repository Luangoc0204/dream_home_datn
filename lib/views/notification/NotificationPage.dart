
import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CommentViewModel.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/PostDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    getNotification();
  }
  getNotification() async {
    User? currentUser = await  context.read<UserViewModel>().currentUser;
    if (currentUser != null){
      await context.read<CommentViewModel>().getAllCommentNotificaion(currentUser.id);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
              child: Consumer<CommentViewModel>(
                builder: (BuildContext context, CommentViewModel commentViewModel, Widget? child) {
                  if (commentViewModel.listCommentNotification == null){
                    return Center(child: Text("You have not had any notification."),);
                  }
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: commentViewModel.listCommentNotification.length,
                      itemBuilder: (context, index){
                        return ItemNotification(idPost: commentViewModel.listCommentNotification[index].post.id, idUser: commentViewModel.listCommentNotification[index].post.author.id, name: commentViewModel.listCommentNotification[index].author.name, avatar: commentViewModel.listCommentNotification[index].author.avatar,);
                      }
                  );
                },
              )
          )
        ],
      )
    );
  }

}
class ItemNotification extends StatelessWidget {
  const ItemNotification({super.key, required this.idPost, required this.idUser, this.avatar, required this.name});
  final String idPost;
  final String idUser;
  final String? avatar;
  final String name;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await context.read<PostViewModel>().getPost(idPost, idUser);
        pushNewScreen(
          context,
          screen: PostDetailPage(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.fromLTRB(10.w,0, 10.w, 0),
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 1
            )
          )
        ),
        height: 75,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
                child: avatar == null
                    ? Image.asset(
                  'assets/img_avatar_empty.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  '${URLImage}user/${avatar}', // Thay thế bằng URL của ảnh
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            SizedBox(width: 10,),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    TextSpan(text: " commented on your post.", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );

  }
}
class Notification {
  final String avatar;
  final String name;

  Notification(this.avatar, this.name);
}
