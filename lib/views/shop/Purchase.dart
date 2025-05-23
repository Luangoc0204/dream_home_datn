import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/shop/ChangeAddress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/Order.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key, required this.listOrder, required this.totalPrice});

  final List<Order> listOrder;
  final num totalPrice;

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late List<Order> listOrder;
  late num totalPrice;
  bool choosePaymentCash = true;
  List<String> ordersId = [];

  @override
  void initState() {
    super.initState();
    listOrder = widget.listOrder;
    totalPrice = widget.totalPrice;
    for (Order order in listOrder) {
      ordersId.add(order.id);
    }
  }

  void purchase() async {
    Cart cart = await context.read<CartViewModel>().cart;
    if (cart.address == null || cart.address == "") {
      FlutterToastr.show("You do not have delivery address", context,
          duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
    } else {
      showAlertDialog(context);
      await context.read<OrderViewModel>().updateOrdered(ordersId);
      print("list Order:" + ordersId.toString());
      await context.read<OrderViewModel>().getAllByCart(cart.id);
      User user = await context.read<UserViewModel>().currentUser;
      await context.read<CartViewModel>().getCart(user.id);
      await Future.delayed(Duration(seconds: 2));
      FlutterToastr.show("Purchase successfully", context,
          duration: FlutterToastr.lengthLong, position: FlutterToastr.bottom);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
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
                  const Text(
                    "Purchase",
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
            height: 20.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.locationDot, size: 15, color: Colors.black54),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: ChangeAddressPage(),
                              withNavBar: false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery",
                                style: TextStyle(fontSize: 14),
                              ),
                              Consumer<CartViewModel>(
                                builder: (BuildContext context, CartViewModel cartViewModel, Widget? child) {
                                  if (cartViewModel.cart.address == null || cartViewModel.cart.address == "") {
                                    return Text("You do not have delivery address",
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16));
                                  } else {
                                    return Text(cartViewModel.cart.address,
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.chevronRight, size: 25, color: Colors.grey),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                itemCount: listOrder.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
                              child: Image.network('${URLImage}product/${listOrder[index].color.url}')),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      listOrder[index].product!.name,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    if (listOrder[index].product!.discount > 0)
                                      Text(
                                        '\$ ${(listOrder[index].product!.price * (100 - listOrder[index].product!.discount) / 100).toStringAsFixed(2)}', // Giá sau khi giảm giá
                                        style: TextStyle(color: mainColor, fontSize: 16),
                                      ),
                                    listOrder[index].product!.discount == 0 ? SizedBox() : SizedBox(width: 5),
                                    Text(
                                      '\$ ${listOrder[index].product!.price.toString()}', // Hiển thị giá gốc nếu có giảm giá
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: listOrder[index].product!.discount == 0 ? mainColor : Colors.grey, // Màu xám cho giá gốc
                                        decoration: listOrder[index].product!.discount == 0 ? null : TextDecoration.lineThrough, // Gạch chéo cho giá gốc
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Color: " + listOrder[index].color.colorName!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "x${listOrder[index].amount.toString()}",
                            style: TextStyle(color: mainColor),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white, border: Border(top: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))),
            constraints: BoxConstraints(minHeight: 30.h),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        choosePaymentCash = !choosePaymentCash;
                      });
                      // pushNewScreen(
                      //   context,
                      //   screen: PurchasePage(listOrder: listOrderPurchase,),
                      //   withNavBar: false, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                          border: Border.all(color: choosePaymentCash ? Colors.white : mainColor, width: 2)),
                      height: 30.h,
                      child: Center(
                        child: Text(
                          "Bank account",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        choosePaymentCash = !choosePaymentCash;
                      });
                      // pushNewScreen(
                      //   context,
                      //   screen: PurchasePage(listOrder: listOrderPurchase,),
                      //   withNavBar: false, // OPTIONAL VALUE. True by default.
                      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                          border: Border.all(color: !choosePaymentCash ? Colors.white : mainColor, width: 2)),
                      child: Center(
                        child: Text(
                          "Cash",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, border: Border(top: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))),
            constraints: BoxConstraints(minHeight: 50.h),
            child: Row(
              children: [
                Spacer(),
                Text(
                  "\$ " + totalPrice.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  onTap: () {
                    purchase();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    color: mainColor,
                    height: 50.h,
                    child: Center(
                      child: Text(
                        "Purchase",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
