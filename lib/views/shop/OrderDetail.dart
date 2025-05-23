import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.order, required this.shop});
  final Shop shop;
  final Order order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
  }
  void updateShippingOrder() async{
    showAlertDialog(context);
    await context.read<OrderViewModel>().updateShippingOrder(widget.order.id);
    await context.read<OrderViewModel>().getAllNotDeliverForShop(widget.shop.id);
    Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.pop(context);
  }
  void deleteOrder() async {
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
                showAlertDialog(context);
                await context.read<OrderViewModel>().deleteOrder(widget.order.id);
                await context.read<OrderViewModel>().getAllNotDeliverForShop(widget.shop.id);
                // Gọi hàm xóa ở đây
                Future.delayed(Duration(seconds: 1));
                Navigator.of(context).pop(); // Đóng Dialog sau khi xóa
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

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
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.black)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Order Detail",
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
          Consumer<OrderViewModel>(
            builder: (BuildContext context, OrderViewModel orderViewModel, Widget? child) {
              if (orderViewModel.order == null)
                return Center(
                    child: CircularProgressIndicator(
                  color: mainColor,
                ));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: Image.network('${URLImage}product/${orderViewModel.order.color.url}')),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      orderViewModel.order.product.name,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      "\$ " + orderViewModel.order.product.price.toString(),
                      style: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      "Color: " +
                          orderViewModel.order.color.colorName! +
                          " | Amount: " +
                          orderViewModel.order.amount.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.locationDot, size: 15, color: Colors.black54),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          orderViewModel.order.cart!.author.name +
                              " - " +
                              orderViewModel.order.cart!.phone.toString() +
                              " - " +
                              orderViewModel.order.address!,
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                              backgroundColor: orderViewModel.order.isShipped ? Colors.grey : mainColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Đặt bo góc cho border
                              ),
                            ),
                            onPressed: (){
                              if (orderViewModel.order.isShipped){

                              } else {
                                updateShippingOrder();
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Shipping",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                )),
                          ),
                        ),
                        if (!orderViewModel.order.isShipped)
                          SizedBox(width: 20,),
                        if (!orderViewModel.order.isShipped)
                        IconButton(
                          onPressed: (){
                            deleteOrder();
                          },
                          icon: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), // Bán kính viền
                              border: Border.all(color: mainColor), // Màu viền
                            ),
                            child: FaIcon(FontAwesomeIcons.trashCan, size: 20, color: mainColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
