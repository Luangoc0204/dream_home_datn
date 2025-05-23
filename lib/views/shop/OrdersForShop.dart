import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/views/home/Home.dart';
import 'package:dreamhome/views/shop/OrderDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class OrdersForShopPage extends StatefulWidget {
  const OrdersForShopPage({super.key, required this.shop});
  final Shop shop;
  @override
  State<OrdersForShopPage> createState() => _OrdersForShopPageState();
}

class _OrdersForShopPageState extends State<OrdersForShopPage> {
  bool selectedShippedPage = false;


  @override
  void initState() {
    super.initState();
    _getListNotDeliverOrder();
  }

  _getListNotDeliverOrder() async {
    await context.read<OrderViewModel>().getAllNotDeliverForShop(widget.shop.id);
  }
  _getListDeliveredOrder() async {
    await context.read<OrderViewModel>().getAllDeliveredForShop(widget.shop.id);
  }
  _getDetailOrder(String idOrder) async{
    await context.read<OrderViewModel>().getOrderDetail(idOrder);
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
                    "Customer's orders",
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _getListNotDeliverOrder();
                    setState(() {
                      selectedShippedPage = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                    elevation: 0,
                    backgroundColor: !selectedShippedPage ? mainColor : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.truckFast, size: 25, color: !selectedShippedPage ? Colors.white : mainColor),
                      Text(
                        "Not delivery",
                        style: TextStyle(fontSize: 20, color: !selectedShippedPage ? Colors.white : Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedShippedPage = true;
                    });
                    _getListDeliveredOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                    elevation: 0,
                    backgroundColor: selectedShippedPage ? mainColor : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.solidStar, size: 25, color: selectedShippedPage ? Colors.white : mainColor),
                      Text(
                        "Delivered",
                        style: TextStyle(fontSize: 20, color: selectedShippedPage ? Colors.white : Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Consumer<OrderViewModel>(
            builder: (BuildContext context, OrderViewModel orderViewModel, Widget? child) {
              List<Order> listOrder = orderViewModel.listOrder;
              return Expanded(
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
                                    pushNewScreen(
                                      context,
                                      screen: OrderDetailPage(order: listOrder[index], shop: widget.shop),
                                      withNavBar: false, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(FontAwesomeIcons.solidEye, size: 14, color: Colors.white),
                                      SizedBox(width: 4.w,),
                                      Text("View", style: TextStyle(color: Colors.white, fontSize: 14),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
              );
            },
          ),
        ],
      ),
    );
  }
}
