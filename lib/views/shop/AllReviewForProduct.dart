import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/viewmodels/ReviewViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AllReviewForProduct extends StatefulWidget {
  const AllReviewForProduct({super.key, required this.product});
  final Product product;
  @override
  State<AllReviewForProduct> createState() => _AllReviewForProductState();
}

class _AllReviewForProductState extends State<AllReviewForProduct> {
  @override
  void initState() {
    super.initState();
    _getListReview();
  }
  _getListReview() async{
    await context.read<ReviewViewModel>().getAllReviewForProduct(widget.product.id, null);
  }
  Widget showRatingReview(num rating) {
    List<Widget> stars = List.generate(5, (index) {
      if (index <= rating-1) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.solidStar, color: Colors.yellow, size: 14,),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.star, color: Colors.yellow, size: 14,),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: stars,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await context.read<ReviewViewModel>().getAllReviewForProduct(widget.product.id, 3);
                          },
                          icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.black)),
                    ),
                  ),
                  Text(
                    "All Reviews",
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
          Expanded(
              child: Consumer<ReviewViewModel>(
                builder: (BuildContext context, ReviewViewModel reviewViewModel, Widget? child) {
                  if (reviewViewModel.listReview.isEmpty){
                    return SizedBox();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    shrinkWrap: true,
                    itemCount: reviewViewModel.listReview.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1
                              )
                            )
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ClipOval(
                                  child: reviewViewModel.listReview[index].author.avatar == null
                                      ? Image.asset(
                                    'assets/img_avatar_empty.jpg',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    '${URLImage}user/${reviewViewModel.listReview[index].author.avatar}',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reviewViewModel.listReview[index].author.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                                    Row(
                                      children: [
                                        Text(reviewViewModel.listReview[index].order.color.colorName),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 3.0, left: 5),
                                          child: showRatingReview(reviewViewModel.listReview[index].rating),
                                        )
                                      ],
                                    ),
                                    Container(
                                        width: 280.w,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(reviewViewModel.listReview[index].content, style: TextStyle(fontSize: 16),),
                                        )
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                      );
                    },
                  );
                },
              )
          )
        ],
      ),
    );
  }
}
