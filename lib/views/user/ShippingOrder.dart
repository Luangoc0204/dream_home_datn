import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/viewmodels/ReviewViewModel.dart';
import 'package:dreamhome/views/user/OrderDetailUser.dart';
import 'package:dreamhome/views/user/RatingForUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ShippingOrderPage extends StatefulWidget {
  const ShippingOrderPage({super.key, required this.title});
  final String title;

  @override
  State<ShippingOrderPage> createState() => _ShippingOrderPageState();
}

class _ShippingOrderPageState extends State<ShippingOrderPage> {
  @override
  void initState() {
    super.initState();
  }
  _getDetailOrder(String idOrder) async{
    await context.read<OrderViewModel>().getOrderDetail(idOrder);
  }
  _getReview(String idOrder) async {
    await context.read<ReviewViewModel>().getReview(idOrder);
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
                    widget.title,
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
          Consumer<OrderViewModel>(
            builder: (BuildContext context, OrderViewModel orderViewModel, Widget? child) {
              List<Order> listOrder = orderViewModel.listOrder;
              return Expanded(
                  child: Container(
                    color: Color(0xFFF8F9FB),
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                        itemCount: listOrder.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(border: Border.all(color: mainColor, width: 1)),
                                      child: Image.network('${URLImage}product/${listOrder[index].color.url}')
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listOrder[index].product!.name,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5.h,),
                                        Text(
                                          "\$ " + listOrder[index].product!.price.toString(),
                                          style: TextStyle(fontSize: 16, color: mainColor),
                                        ),
                                        SizedBox(height: 10.h,),
                                        IntrinsicWidth(
                                          child: Container(
                                            height: 25.h,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xFFF1F3F6)
                                            ),
                                            child: Text(
                                              "Color: " +
                                                  listOrder[index].color.colorName! +
                                                  " | Amount: " +
                                                  listOrder[index].amount.toString(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                      backgroundColor: mainColor,
                                      elevation:0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5), // Đặt bo góc cho border
                                      ),
                                    ),
                                    onPressed: () {
                                      _getDetailOrder(listOrder[index].id);
                                      if (listOrder[index].isPaid) _getReview(listOrder[index].id);
                                      pushNewScreen(
                                        context,
                                        screen: !listOrder[index].isPaid ? OrderDetailUserPage(order: listOrder[index]) : RatingForUserPage(order: listOrder[index]),
                                        withNavBar: false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(listOrder[index].isPaid ? FontAwesomeIcons.solidStar : FontAwesomeIcons.solidEye, size: 14, color: Colors.white),
                                        SizedBox(width: 4.w,),
                                        Text(listOrder[index].isPaid ? "Rating" : "View", style: TextStyle(color: Colors.white, fontSize: 14),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}
