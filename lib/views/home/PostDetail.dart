import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Comment.dart';
import 'package:dreamhome/models/Like.dart';
import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CommentViewModel.dart';
import 'package:dreamhome/viewmodels/LikeViewModel.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/AddEditPost.dart';
import 'package:dreamhome/views/user/DetailUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, this.owner = false});

  final bool owner;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Post post;
  late Like like;

  TextEditingController _commentController = TextEditingController();
  Widget commentLoadingWidget = Container();

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
  Future<Comment?> addComment(String content) async {
    if (content != ""){
      User user = await context.read<UserViewModel>().currentUser;
      Comment comment = Comment.noId(content, user, this.post);
      await context.read<CommentViewModel>().addComment(comment);
      Comment commentResponse =  await context.read<CommentViewModel>().comment;
      await context.read<PostViewModel>().getAllPost(user.id);
      return commentResponse;
    }
    return null;
  }
  _deletePost() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<PostViewModel>().deletePost(post.id);
                await context.read<PostViewModel>().getAllPost(post.author.id);
                await context.read<PostViewModel>().getAllPostPersonal(post.author.id);
                // Gọi hàm xóa ở đây
                Navigator.of(context).pop(); // Đóng Dialog sau khi xóa
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  Future<void> addLike() async {
    User user = await context.read<UserViewModel>().currentUser;
    Like likeAdd = Like.noId(user, post);
    await context.read<LikeViewModel>().addLike(likeAdd);
    this.like = await context.read<LikeViewModel>().like;
    setState(() {
      post.like = this.like;
      post.totalLike += 1;
    });
  }
  Future<void> deleteLike() async {
    try {
      await context.read<LikeViewModel>().deleteLike(this.like.id);
      if (post.totalLike > 0){
        setState(() {
          post.like = null;
          post.totalLike -= 1;
        });
      }
    } catch (error) {
      debugPrint("Error delete like: $error");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<PostViewModel>(
        builder: (BuildContext context, PostViewModel postViewModel, Widget? child) {
          post = postViewModel.post;
          if (post.like != null){
            like = post.like!;
          }
          return SingleChildScrollView(
            child: Column(
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                          child: postViewModel.post.author.avatar == null
                              ? Image.asset(
                            'assets/img_avatar_empty.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            '${URLImage}user/${postViewModel.post.author.avatar}', // Thay thế bằng URL của ảnh
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: DetailUserPage(
                                    user: postViewModel.post.author,
                                  ),
                                  withNavBar: false, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Text(
                                postViewModel.post.author.name,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Text(
                              formatDateTime(postViewModel.post.created_at),
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      widget.owner
                          ? CustomPopup(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      pushNewScreen(
                                        context,
                                        screen: AddEditPostPage(
                                          post: postViewModel.post,
                                        ),
                                        withNavBar: false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    icon: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        FaIcon(FontAwesomeIcons.pencil, size: 15, color: Colors.greenAccent),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          "Edit",
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        )
                                      ],
                                    )),
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deletePost();
                                    },
                                    icon: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.trashCan, size: 15, color: Colors.redAccent),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          "Delete",
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        )
                                      ],
                                    )),
                              )
                            ],
                          ),
                          child: Icon(Icons.more_vert))
                          : SizedBox()
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Text(postViewModel.post.content, style: TextStyle(fontSize: 16),),
                ),
                if (postViewModel.post.image != null)
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: postViewModel.post.image!.length,
                      itemBuilder: (context, index){
                        return Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  '${URLImage}post/'+postViewModel.post.image![index], // Thay thế bằng URL của ảnh
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        );
                      }
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(postViewModel.post.totalLike.toString(), style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
                      SizedBox(width: 5,),
                      Container(
                          padding: EdgeInsets.only(bottom: 1),
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: mainColor, // Màu nền của hình tròn
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidThumbsUp,
                              size: 13,
                              color: Colors.white,
                            ),
                          )
                      ),
                      SizedBox(width: 5,),
                      Text(postViewModel.post.totalComment.toString(), style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
                      SizedBox(width: 5,),
                      Container(
                          padding: EdgeInsets.only(bottom: 0),
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue, // Màu nền của hình tròn
                          ),
                          child: Center(
                              child: Icon(Icons.chat, size: 13, color: Colors.white,)
                          )
                      ),

                    ],
                  ),
                ),
                Divider(height: 1, color: Color(0xFF1C1E21).withOpacity(0.2), thickness: 1,),
                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LikeButton(
                                padding: EdgeInsets.only(bottom: 5),
                                size: 30,
                                isLiked: postViewModel.post.like != null ? true : false,
                                onTap: (bool isLiked) async {
                                  if (!isLiked) {
                                    addLike();
                                  } else {
                                    deleteLike();
                                  }
                                  return !isLiked;
                                },
                                animationDuration: Duration(milliseconds: 1000),
                                likeBuilder: (bool isLiked) {
                                  return isLiked ? FaIcon(
                                    FontAwesomeIcons.solidThumbsUp,
                                    size: 30,
                                    color: mainColor,
                                  ) : FaIcon(
                                    FontAwesomeIcons.thumbsUp,
                                    size: 30,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                              SizedBox(width: 5),
                              Text("Like"),

                            ],
                          )
                      ),
                      Expanded(
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.message, size: 25, color: Colors.grey,),
                                SizedBox(width: 10),
                                Text("Comment")
                              ],
                            ),
                          )

                      ),

                    ],
                  ),
                ),
                Divider(height: 1, color: Color(0xFF1C1E21).withOpacity(0.2), thickness: 1,),
                commentLoadingWidget,
                ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postViewModel.post.comments.length,
                  itemBuilder: (context, index) {
                    return commentIndex(postViewModel.post.comments[index]);
                  },
                  reverse: true,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 8, left: 8, right: 8, top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _commentController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15.0),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.6),
                              hintText: 'Add comment ...',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: mainColor, width: 1.5),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: mainColor, width: 1.5),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: IconButton(
                            onPressed: () async {
                              // Xử lý khi nhấn nút gửi
                              String content = _commentController.text.trim();
                              if (content != "") {
                                User user = await context.read<UserViewModel>().currentUser;
                                Comment comment = Comment.noId(
                                    content, user, postViewModel.post);
                                setState((){
                                  this.post.totalComment += 1;

                                  commentLoadingWidget = commentLoading(comment);
                                  _commentController.clear();
                                  FocusScope.of(context).unfocus(); // Đóng bàn phím
                                });
                              }
                              Comment? comment = await addComment(content);
                              await Future.delayed(Duration(seconds: 2));
                              if (comment != null) {
                                setState((){
                                  commentLoadingWidget = Container();
                                  this.post.comments.add(comment);
                                });
                              } else {
                                setState((){
                                  commentLoadingWidget = Container();
                                  this.post.totalComment -= 1;

                                });
                                FlutterToastr.show("Failed to comment!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);

                              }

                            },
                            icon: Icon(Icons.send_rounded, color: mainColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  Widget commentIndex(Comment comment) => Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                  child: comment.author.avatar == null
                      ? Image.asset(
                    'assets/img_avatar_empty.jpg',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    '${URLImage}user/${comment.author.avatar}', // Thay thế bằng URL của ảnh
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  )),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){

                          },
                          child: Text(
                            comment.author.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Text(comment.content, style: TextStyle( fontSize: 16),)
                      ],

                    ),
                  )
              )
            ],
          ),
          SizedBox(height: 10,),
          Divider(height: 1, color: Color(0xFF1C1E21).withOpacity(0.1), thickness: 1,),

        ]
    ),
  );
  Widget commentLoading(Comment comment) => Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipOval(
                    child: comment.author.avatar == null
                        ? Image.asset(
                      'assets/img_avatar_empty.jpg',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      '${URLImage}user/${comment.author.avatar}', // Thay thế bằng URL của ảnh
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    )),
              ),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){

                          },
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              comment.author.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        Opacity(opacity: 0.5, child: Text(comment.content, style: TextStyle( fontSize: 16),),),
                        Lottie.asset("assets/lottie/loading_dots.json", height: 20, fit: BoxFit.fill),

                      ],

                    ),
                  )
              )
            ],
          ),
          Divider(height: 1, color: Color(0xFF1C1E21).withOpacity(0.1), thickness: 1,),

        ]
    ),
  );
}
