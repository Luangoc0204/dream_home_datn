
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
import 'package:dreamhome/views/home/DetailChatUser.dart';
import 'package:dreamhome/views/user/DetailUser.dart';
import 'package:dreamhome/views/user/PersonalPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PostBox extends StatefulWidget {
  Post post;
  PostBox({super.key, required this.post, this.owner = false });
  final bool owner;
  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
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
                await context.read<PostViewModel>().deletePost(widget.post.id);
                await context.read<PostViewModel>().getAllPost(widget.post.author.id);
                await context.read<PostViewModel>().getAllPostPersonal(widget.post.author.id);
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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                      child: widget.post.author.avatar == null
                          ? Image.asset(
                        'assets/img_avatar_empty.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        '${URLImage}user/${widget.post.author.avatar}', // Thay thế bằng URL của ảnh
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
                          onTap: () async {
                            if (widget.owner){
                              User? currentUser = await context.read<UserViewModel>().currentUser;
                              if (currentUser != null)
                                await context.read<PostViewModel>().getAllPostPersonal(currentUser.id);
                              pushNewScreen(
                                context,
                                screen: const PersonalPage(),
                                withNavBar: false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            } else {
                              pushNewScreen(
                                context,
                                screen: DetailUserPage(user: widget.post.author,),
                                withNavBar: false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            }
                          },
                          child: Text(
                            widget.post.author.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Text(
                          formatDateTime(widget.post.created_at),
                          style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  widget.owner ? CustomPopup(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  pushNewScreen(
                                    context,
                                    screen: AddEditPostPage(post: widget.post,),
                                    withNavBar: false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );
                                },
                                icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.pencil,
                                      size: 15,
                                      color: Colors.greenAccent),
                                    SizedBox(width: 10.w,),
                                    Text("Edit", style: TextStyle(fontSize: 18, color: Colors.black),)
                                  ],
                                )
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  _deletePost();

                                },
                                icon: Row(
                                  children: [
                                    FaIcon(
                                        FontAwesomeIcons.trashCan,
                                        size: 15,
                                        color: Colors.redAccent),
                                    SizedBox(width: 10.w,),
                                    Text("Delete", style: TextStyle(fontSize: 18, color: Colors.black),)
                                  ],
                                )
                            ),
                          )
                        ],
                      ),
                      child: Icon(Icons.more_vert)
                  )
                   : SizedBox()

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: Text(widget.post.content, style: TextStyle(fontSize: 16),),
            ),
            widget.post.image!.length == 0 ? Container() : buildImagePost(),
            LikeBox(post: widget.post,),
            Divider(height: 5, color: Color(0xFF1C1E21).withOpacity(0.1), thickness: 5,),

          ],
        )
      );
  }
  Widget buildImagePost(){
    if (widget.post.image!.length == 1){
      return Image.network(
        '${URLImage}post/'+widget.post.image![0],
        width: MediaQuery.of(context).size.width,// Thay thế bằng URL của ảnh
        fit: BoxFit.cover,
      );
    } else if (widget.post.image!.length == 2){
      return StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 2,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![0], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 2,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![1], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          )
        ],
      );
    } else if (widget.post.image!.length == 3){
      return StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![2], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 2,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![1], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![0], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),


        ],
      );
    } else if (widget.post.image!.length == 4 ){
      return StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![2], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![3], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![0], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![1], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    } else {
      return StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/'+widget.post.image![2], // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Stack(
              children:[
                Positioned.fill(
                    child: Image.network(
                      '${URLImage}post/'+widget.post.image![3], // Thay thế bằng URL của ảnh
                      fit: BoxFit.cover,
                    ),
                ),

                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Mức độ mờ của lớp
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      "+${widget.post.image!.length - 4}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/${widget.post.image![0]}', // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Image.network(
              '${URLImage}post/${widget.post.image![1]}', // Thay thế bằng URL của ảnh
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }
  }

}
class LikeBox extends StatefulWidget {
  Post post;
  LikeBox({super.key, required this.post});

  @override
  State<LikeBox> createState() => _LikeBoxState(this.post);
}

class _LikeBoxState extends State<LikeBox> {
  Post post;
  late Like like;
  _LikeBoxState(this.post);
  bool _dataLoaded = false;
  TextEditingController _commentController = TextEditingController();
  Widget commentLoadingWidget = Container();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (post.like != null){
      like = post.like!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.totalLike.toString(), style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
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
                  Text(this.post.totalComment.toString(), style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
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
                            isLiked: post.like != null ? true : false,
                            size: 30,
                            animationDuration: Duration(milliseconds: 1000),
                            onTap: (bool isLiked) async {
                              if (!isLiked) {
                                addLike();
                              } else {
                                deleteLike();
                              }
                              return !isLiked;
                            },
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
                        onTap: () async {
                          await _getComment(this.post.id);
                          showCommentBox();
                        },
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
            )
          ],
        )
    );
  }
  Future<void> _getComment(String id) async {
    User user = await context.read<UserViewModel>().currentUser;
    await context.read<PostViewModel>().getPost(id, user.id);
    setState(() {
      _dataLoaded = true;
      this.post = context.read<PostViewModel>().post;
    });
  }

  Future<Comment?> addComment(String content) async {
    if (content != ""){
      User user = await context.read<UserViewModel>().currentUser;
      Comment comment = Comment.noId(content, user, this.post);
      await context.read<CommentViewModel>().addComment(comment);
      Comment commentResponse =  await context.read<CommentViewModel>().comment;
      return commentResponse;
    }
    return null;
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
  Widget makeDismissible({required Widget child,required BuildContext context}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: ()=> Navigator.pop(context),
    child: GestureDetector(onTap: (){}, child: child,),
  );
  showCommentBox() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return makeDismissible(
              context: context,
              child: StatefulBuilder(
                  builder: (context, setNewState) {
                    return DraggableScrollableSheet(
                        initialChildSize: 0.7,
                        minChildSize: 0.5,
                        maxChildSize: 0.9,
                        builder: (_, controller) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)
                            ),
                            color: Colors.white,

                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 60,),
                                  Expanded(
                                      child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(post.totalComment.toString(), style: TextStyle(fontSize: 16)),
                                              Text(" comments", style: TextStyle(fontSize: 16)),

                                            ],
                                          )
                                      )
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    icon: FaIcon(FontAwesomeIcons.xmark, size: 25, color: Colors.grey),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child:  Divider(height: 1, color: Color(0xFF1C1E21).withOpacity(0.3), thickness: 1,),

                              ),
                              Expanded(
                                  child: !_dataLoaded ? Center(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                  ): (this.post.totalComment ==0 ?
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.forum, color: Colors.grey.withOpacity(0.5), size: 50,),
                                        Text("No comment yets", style: TextStyle(fontSize: 20, color: Colors.grey),),
                                        Text("Be the first to comment.", style: TextStyle(fontSize: 20, color: Colors.grey),)
                                      ],
                                    ),
                                  ) : ListView(
                                    controller: controller,
                                    children: [
                                      commentLoadingWidget,
                                      ListView.builder(
                                        padding: EdgeInsets.only(top: 0),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: post.comments.length,
                                        itemBuilder: (context, index) {
                                          return commentIndex(post.comments[index]);
                                        },
                                        reverse: true,
                                      )
                                    ],
                                  )
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 8, left: 8, right: 8, top: 8),
                                child: Consumer<CommentViewModel>(
                                  builder: (context, commentViewModel, child) {
                                    return Row(
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
                                                    content, user, this.post);
                                                setNewState((){
                                                  this.post.totalComment += 1;

                                                  commentLoadingWidget = commentLoading(comment);
                                                  _commentController.clear();
                                                  FocusScope.of(context).unfocus(); // Đóng bàn phím
                                                });
                                              }
                                              Comment? comment = await addComment(content);
                                              await Future.delayed(Duration(seconds: 2));
                                              if (comment != null) {
                                                setNewState((){
                                                  commentLoadingWidget = Container();
                                                  this.post.comments.add(comment);
                                                });
                                              } else {
                                                setNewState((){
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
                                    );
                                  },
                                ),
                              )

                            ],
                          ),


                        )
                    );
                  }
              )
          );
        }
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





