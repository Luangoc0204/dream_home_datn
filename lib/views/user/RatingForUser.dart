import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/models/Review.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/ReviewViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RatingForUserPage extends StatefulWidget {
  const RatingForUserPage({super.key, required this.order});
  final Order order;
  @override
  State<RatingForUserPage> createState() => _RatingForUserPageState();
}

class _RatingForUserPageState extends State<RatingForUserPage> {
  List<bool> listStarRating = [true, true, true, true, true];
  int selectQuality = 4;
  List<String> listQualityProductText = ["Terrible", "Poor", "Fair", "Good", "Amazing"];
  final TextEditingController ratingController = TextEditingController();
  bool haveReview = false;

  Review? review;

  _getReview() async {
    review = await context.read<ReviewViewModel>().review;
    if (review != null){
      setState(() {
        ratingController.text = review!.content;
        selectQuality = review!.rating - 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getReview();
  }

  void addReview() async {
    if (ratingController.text.trim().isEmpty){
      FlutterToastr.show("Review is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
    } else {
      showAlertDialog(context);
      int rating = selectQuality + 1;
      String content = ratingController.text.trim();
      User user = await context.read<UserViewModel>().currentUser;
      Review review = Review.noId(content, rating, widget.order.product!, widget.order, user);
      await context.read<ReviewViewModel>().addReview(review);
      Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      Navigator.pop(context);
      FlutterToastr.show("Rating successfully", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
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
      body: Consumer<ReviewViewModel>(
        builder: (BuildContext context, ReviewViewModel reviewViewModel, Widget? child) {
          if (reviewViewModel.review != null){
            ratingController.text = reviewViewModel.review!.content;
            selectQuality = reviewViewModel.review!.rating - 1;
          }
          return Column(
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
                        "Rating",
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
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Image.network('${URLImage}product/${widget.order.color.url}')
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Text(
                            widget.order.product!.name,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Text(
                            "Color: " +
                                widget.order.color.colorName!,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20.w,),
                  IntrinsicWidth(child: Text("Product Quality: ", style: TextStyle(fontSize: 18, color: Colors.black),)),
                  SizedBox(width: 10.w,),
                  Text(listQualityProductText[selectQuality], style: TextStyle(fontSize: 18, color: mainColor),)
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                child: reviewViewModel.review != null ?
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      debugPrint("index: $index");
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: FaIcon(
                            index <= reviewViewModel.review!.rating - 1 ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star, // Sử dụng biến isLiked thay vì listStarRating[index]
                            size: 30,
                            color: index <= reviewViewModel.review!.rating - 1 ? mainColor : Colors.grey, // Sử dụng biến isLiked thay vì listStarRating[index]
                          )
                      );
                    }
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listStarRating.length,
                    itemBuilder: (context, index){
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                          LikeButton(
                            padding: EdgeInsets.only(bottom: 5),
                            isLiked: listStarRating[index],
                            size: 30,
                            animationDuration: Duration(milliseconds: 1000),
                            likeBuilder: (bool isLiked) {
                              return FaIcon(
                                isLiked ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star, // Sử dụng biến isLiked thay vì listStarRating[index]
                                size: 30,
                                color: isLiked ? mainColor : Colors.grey, // Sử dụng biến isLiked thay vì listStarRating[index]
                              );
                            },
                            onTap: (bool isLiked) async {
                              setState(() {
                                selectQuality = index;
                                // Kiểm tra xem vị trí của icon sao được click có nhỏ hơn vị trí của icon sao hiện tại hay không
                                for (int i = 0; i < listStarRating.length; i++) {
                                  if (i <= index) {
                                    listStarRating[i] = true; // Icon có số thứ tự nhỏ hơn hoặc bằng vị trí của icon hiện tại thành true
                                  } else {
                                    listStarRating[i] = false; // Icon có số thứ tự lớn hơn vị trí của icon hiện tại thành false
                                  }
                                }
                              });
                              return !isLiked;
                            },
                          )
                      );
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  height: 100.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withOpacity(0.15)
                  ),
                  child: TextField(
                    enabled: reviewViewModel.review == null ? true : false,
                    expands: true,
                    controller: ratingController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    maxLength: 50,
                    decoration: InputDecoration(
                        isCollapsed: false,
                        hintText: "Share your review ...",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none
                    ),
                    onChanged: (value) {
                      if (value.trim().isNotEmpty){
                        setState(() {
                          haveReview = true;
                        });
                      } else {
                        setState(() {
                          haveReview = false;
                        });
                      }
                    },
                  ),
                ),
              ),
              reviewViewModel.review == null ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          backgroundColor: haveReview ? mainColor : Colors.grey.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Đặt bo góc cho border
                          ),
                        ),
                        onPressed: (){
                          addReview();
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
              ) :  SizedBox()

            ],
          );
        },
      ),
    );
  }
}
