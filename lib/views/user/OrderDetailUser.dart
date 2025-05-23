import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/OrderViewModel.dart';

class OrderDetailUserPage extends StatefulWidget {
  final Order order;

  const OrderDetailUserPage({super.key, required this.order});

  @override
  State<OrderDetailUserPage> createState() => _OrderDetailUserPageState();
}

class _OrderDetailUserPageState extends State<OrderDetailUserPage> {

  void deleteOrder() async {
    showAlertDialog(context);
    await context.read<OrderViewModel>().deleteOrder(widget.order.id);
    Cart? cart = await context.read<CartViewModel>().cart;
    if (cart != null) await context.read<OrderViewModel>().getAllNotDeliverForUser(cart.id);

    Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.pop(context);
  }
  void updatePaidOrder() async {
    showAlertDialog(context);
    await context.read<OrderViewModel>().updatePaidOrder(widget.order.id);
    Cart? cart = await context.read<CartViewModel>().cart;
    if (cart != null) await context.read<OrderViewModel>().getAllNotDeliverForUser(cart.id);

    Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.pop(context);
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
                  orderViewModel.order.isShipped ? Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text("Your order is shipping to you", style: TextStyle(color: mainColor, fontSize: 20),),
                  ) : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                              backgroundColor: mainColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Đặt bo góc cho border
                              ),
                            ),
                            onPressed: (){
                              if (orderViewModel.order.isShipped){
                                updatePaidOrder();
                              } else {
                                deleteOrder();
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  orderViewModel.order.isShipped ? "Order Received" : "Cancel order",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                )),
                          ),
                        ),
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
